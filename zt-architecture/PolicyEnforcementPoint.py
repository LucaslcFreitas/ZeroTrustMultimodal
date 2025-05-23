import socket
import ssl
import concurrent.futures
import os
import logging
import Response
from PolicyDecisionPoint import PolicyDecisionPoint

class PolicyEnforcementPoint:
    config = {
        "ip_address": None,
        "port": None
    }
    
    def __init__(self) -> None:
        try:
            hostname = socket.gethostname()
            self.config['ip_address'] = socket.gethostbyname(hostname)
            self.config['port'] = int(os.getenv("PORT", 5000))
        except Exception as e:
            logging.error("Error in PEP - " + e)
            exit()
    
    # Inicia o PEP e dispara uma thread para cada requisição
    def start(self):
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
            sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            sock.bind((self.config['ip_address'], self.config['port']))
            sock.listen()

            logging.info("Zero Trust server started!")
            logging.info(f'Waiting for connections at {self.config["ip_address"]}:{self.config["port"]}')

            with concurrent.futures.ThreadPoolExecutor() as executor:
                while True:
                    conn, addr = sock.accept()
                    logging.info(f'Connection received from {addr}')

                    context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
                    context.load_cert_chain(os.path.dirname(os.path.abspath(__file__)) + '/server.crt', os.path.dirname(os.path.abspath(__file__)) + '/server.key')
                    conn = context.wrap_socket(conn, server_side=True)

                    executor.submit(self.handle_client, conn, addr)

    # Thread para tratar requisição do usuário
    def handle_client(self, conn, addr) -> None:
        logging.info(f'Start thred from {addr}')

        pdp = PolicyDecisionPoint()

        opReauthentication = {
            "inReauthentication": False,
            "idAccess": None
        }
        tmpCount = 0
        while(True):

            decision = None
            body = None

            data = conn.recv(1024)
            if not data:
                break
            message = data.decode('utf-8')

            if "REAUTHENTICATION" not in message:
                tmpCount += 1

            if tmpCount >= 101:
                print(tmpCount)
            # Operação de reautenticação
            if opReauthentication["inReauthentication"]:
                message += "ID_ACCESS "+str(opReauthentication["idAccess"])+"\n"
        
            try:
                decision, body = pdp.policyAdministrator(message)
            except Exception as e:
                logging.error("Error in PA - " + e)


            match(decision):
                case Response.ACCESS_ALLOWED: # Conexão autorizada
                    if body["ipAddress"] and body["port"]:
                        logging.info(f'Authorized request for {addr}')
                        sockResource = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                        sockResource.connect((body["ipAddress"], body["port"]))
                        responseResource = "ACCESS_ALLOWED\nRESPONSE " + sockResource.recv(1024).decode('utf-8')
                        conn.sendall(responseResource.encode('utf-8'))
                        sockResource.close()
                    else:
                        logging.error(f'Internal server error')
                        result = "INTERNAL_SERVER_ERROR"
                        conn.sendall(result.encode('utf-8'))
                case Response.ACCESS_DENIED:
                    logging.info(f'Denied request for {addr}')
                    result = "ACCESS_DENIED"
                    conn.sendall(result.encode('utf-8'))
                case Response.RESOURCE_NOT_FOUND:
                    logging.info(f'Denied request for {addr}')
                    result = "RESOURCE_NOT_FOUND"
                    conn.sendall(result.encode('utf-8'))
                case Response.AUTHENTICATION_REQUIRED:
                    if body["idpIp"] and body["idpPort"] and body["authorizationCode"]:
                        logging.info(f'Redirect login for {addr}')
                        result = "AUTHENTICATION_REQUIRED\nIDP_IP " + body["idpIp"] + "\nIDP_PORT " + body["idpPort"] + "\nAUTHORIZATION_CODE " + body["authorizationCode"] + "\nTYPE_LOGIN " + body["typeLogin"]
                        conn.sendall(result.encode('utf-8'))
                    else :
                        logging.error(f'Login error for {addr}')
                        result = "INTERNAL_SERVER_ERROR"
                        conn.sendall(result.encode('utf-8'))
                case Response.REAUTHENTICATION_REQUIRED:
                    if body["idAccess"]:
                        if opReauthentication["inReauthentication"]:
                            pdp.registerDeniedForNotReauthentication(opReauthentication["idAccess"])
                            opReauthentication["inReauthentication"] = False
                            opReauthentication["idAccess"] = None
                        logging.info(f'Reauthentication required for {addr}')   
                        opReauthentication["inReauthentication"] = True
                        opReauthentication["idAccess"] = body["idAccess"]
                        result = "REAUTHENTICATION_REQUIRED\nIDP_IP " + body["idpIp"] + "\nIDP_PORT " + str(body["idpPort"]) + "\nAUTHORIZATION_CODE " + body["authorizationCode"] + "\nTYPE_LOGIN " + body["typeLogin"]
                        conn.sendall(result.encode('utf-8'))
                    else:
                        logging.error(f'Internal server error')
                        result = "INTERNAL_SERVER_ERROR"
                        conn.sendall(result.encode('utf-8'))
                case Response.REAUTHENTICATION_ALLOWED:
                    if body["ipAddress"] and body["port"]:
                        logging.info(f'Reauthentication allowed for {addr}')
                        sockResource = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                        sockResource.connect((body["ipAddress"], body["port"]))
                        responseResource = "REAUTHENTICATION_ALLOWED\nRESPONSE " + sockResource.recv(1024).decode('utf-8')
                        conn.sendall(responseResource.encode('utf-8'))
                        sockResource.close()

                        opReauthentication["inReauthentication"] = False
                        opReauthentication["idAccess"] = None
                    else:
                        logging.error(f'Internal server error')
                        result = "INTERNAL_SERVER_ERROR"
                        conn.sendall(result.encode('utf-8'))
                case Response.AUTHORIZED_REGISTRY:
                    if body["idpIp"] and body["idpPort"] and body["registryCode"]:
                        logging.info(f'Redirect registry for {addr}')
                        result = "AUTHORIZED_REGISTRY\nIDP_IP " + body["idpIp"] + "\nIDP_PORT " + str(body["idpPort"]) + "\nREGISTRY_CODE " + body["registryCode"]
                        conn.sendall(result.encode('utf-8'))
                    else :
                        logging.error(f'Registry error for {addr}')
                        result = "INTERNAL_SERVER_ERROR"
                        conn.sendall(result.encode('utf-8'))
                case Response.AUTHORIZED_LOGIN:
                    if body["idpIp"] and body["idpPort"] and body["authorizationCode"]:
                        logging.info(f'Redirect login for {addr}')
                        result = "AUTHORIZED_LOGIN\nIDP_IP " + body["idpIp"] + "\nIDP_PORT " + str(body["idpPort"]) + "\nAUTHORIZATION_CODE " + body["authorizationCode"] + "\nTYPE_LOGIN " + body["typeLogin"]
                        conn.sendall(result.encode('utf-8'))
                    else :
                        logging.error(f'Login error for {addr}')
                        result = "INTERNAL_SERVER_ERROR"
                        conn.sendall(result.encode('utf-8'))
                case Response.UPDATED_PASSWORD:
                    if body['token']:
                        logging.info(f'Updated password for {addr}')
                        result = "UPDATED_PASSWORD\nTOKEN " + body["token"]
                        conn.sendall(result.encode('utf-8'))
                    else:
                        logging.error(f'Updated password error for {addr}')
                        result = "INTERNAL_SERVER_ERROR"
                        conn.sendall(result.encode('utf-8'))
                case Response.UNAUTHORIZED_PASSWORD_UPDATE:
                    logging.info(f'Unauthorized password update for {addr}')
                    result = "UNAUTHORIZED_PASSWORD_UPDATE"
                    conn.sendall(result.encode('utf-8'))
                case Response.UNAUTHORIZED_REGISTRY:
                    logging.info(f'Unauthorized registry for {addr}')
                    result = "UNAUTHORIZED_REGISTRY"
                    conn.sendall(result.encode('utf-8'))
                case Response.INTERNAL_SERVER_ERROR:
                    logging.error(f'Internal server error')
                    result = "INTERNAL_SERVER_ERROR"
                    conn.sendall(result.encode('utf-8'))
                case Response.ENDPOINT_NOT_IMPLEMENTED:
                    logging.error(f'Update password is not implemented')
                    result = "UPDATE_PASSWORD_IS_NOT_IMPLEMENTED"
                    conn.sendall(result.encode('utf-8'))
                case _: #default
                    result = "INTERNAL_SERVER_ERROR"
                    conn.sendall(result.encode('utf-8'))
                    logging.error(f'Unidentified answer for {addr}')
                    logging.info(f'Connection closed with {addr}')
                    conn.close()
                    break  

            if opReauthentication["inReauthentication"] and (decision != Response.REAUTHENTICATION_REQUIRED and decision != Response.REAUTHENTICATION_ALLOWED):
                pdp.registerDeniedForNotReauthentication(opReauthentication["idAccess"])
                opReauthentication["inReauthentication"] = False
                opReauthentication["idAccess"] = None
        logging.info(f'Connection closed with {addr}')
        conn.close()


if __name__ == '__main__':
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
    pep = PolicyEnforcementPoint()
    pep.start()