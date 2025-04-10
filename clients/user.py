import socket
import ssl
import os
import json
import time

def startAccess():
    print("antes do sleep")
    time.sleep(5)
    print("depois do sleep")
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        print("with socket")
        HOST = os.getenv("IP_ZERO_TRUST", '192.168.56.1')
        PORT = int(os.getenv("PORT_ZERO_TRUST", 5000))

        # Dados dos usuários
        users = {}

        # Operações de acesso
        operations_json = os.getenv("OPERATIONS") 
        # operations_json = os.getenv("OPERATIONS", getFakeOperations())
        print("operation_json")

        if operations_json:
            operations = json.loads(operations_json)
        else:
            print("No operations found")
            exit()
        
        try:
            print("dados da conexão")
            # Conexão com o servidor Zero Trust (aceitando certificado ssl auto assinado)
            context = ssl.create_default_context(ssl.Purpose.SERVER_AUTH)
            context.check_hostname = False
            context.verify_mode = ssl.CERT_NONE
            conn = context.wrap_socket(sock, server_hostname=HOST)

            print("antes da conexão")
            conn.connect((HOST, PORT))
            print(f'Conected to {HOST}:{PORT}')

        except Exception as e:
            print(e)
            exit()

        average_time = 0.0
        access_count = 0

        if operations:
            print(len(operations))
            for access in operations:
                print(access["TYPE"])
                match (access['TYPE']):
                    case 'LOGIN':
                        message = getLogin(access['REGISTRY'], access['IP_ADDRESS'], access['LATITUDE'], access['LONGITUDE'], access['MAC'], access['DFP'], access['OS'], access['VERSION_OS'], access['TIME'])

                        conn.sendall(message.encode('utf-8'))

                        data = conn.recv(1024)
                        response = data.decode('utf-8')
                        lines = response.strip().split('\n')
                        data = {}
                        data['RESULT'] = lines[0]
                        for line in lines[1:]:
                            key, value = line.split(' ', 1)
                            data[key] = value
                        if data['RESULT'] == 'AUTHENTICATION_REQUIRED' or data['RESULT'] == 'AUTHORIZED_LOGIN':
                            if data['IDP_IP'] and data['IDP_PORT'] and data['AUTHORIZATION_CODE']:
                                resultLogin = login(data['IDP_IP'], data['IDP_PORT'], data['AUTHORIZATION_CODE'], access['REGISTRY'], access['TIME'], access['MAC'], access['DFP'])
                                
                                if resultLogin['status'] == 'success' and resultLogin['token']:
                                    users[access['REGISTRY']] = resultLogin['token']
                                    print(users)
                                else:
                                    print('Failed to login on IDP server')
                                    break
                            else:
                                print("Login error")
                                break
                        elif access['REGISTRY'] in users and users[access['REGISTRY']] != None:
                            print("Login error")
                            break
                    
                    case 'ACCESS':
                        message = getAccess(access['RESOURCE'], access['SUB_RESOURCE'], access['TYPE_ACTION'], users[access['REGISTRY']], access['IP_ADDRESS'], access['LATITUDE'], access['LONGITUDE'], access['MAC'], access['DFP'], access['OS'],  access['VERSION_OS'], access['TIME'])
                                                
                        time_start = time.time()

                        conn.sendall(message.encode('utf-8'))
                        data = conn.recv(1024)
                        
                        time_end = time.time()

                        response = data.decode('utf-8')
                        lines = response.strip().split('\n')
                        data = {}
                        data['RESULT'] = lines[0]
                        for line in lines[1:]:
                            key, value = line.split(' ', 1)
                            data[key] = value

                        average_time += (time_end - time_start)
                        access_count += 1

                        if data['RESULT'] == "AUTHENTICATION_REQUIRED":
                            if data['IDP_IP'] and data['IDP_PORT'] and data['AUTHORIZATION_CODE']:
                                resultLogin = login(data['IDP_IP'], data['IDP_PORT'], data['AUTHORIZATION_CODE'], access['REGISTRY'], access['TIME'], access['MAC'], access['DFP'])

                                if resultLogin['status'] == 'success' and resultLogin['token']:
                                    users[access['REGISTRY']] = resultLogin['token']
                                    message = getAccess(access['RESOURCE'], access['SUB_RESOURCE'], access['TYPE_ACTION'], users[access['REGISTRY']], access['IP_ADDRESS'], access['LATITUDE'], access['LONGITUDE'], access['MAC'], access['DFP'], access['OS'], access['VERSION_OS'], access['TIME'])
                                
                                    conn.sendall(message.encode('utf-8'))
                                    data = conn.recv(1024)
                                    response = data.decode('utf-8')
                                    print(response)
                                else:
                                    print('Failed to login on IDP server after access')
                            else:
                                print("Access error on authentication")
                                break

                        if data['RESULT'] == "REAUTHENTICATION_REQUIRED" and access['REAUTHENTICATE']:
                            if data['IDP_IP'] and data['IDP_PORT'] and data['AUTHORIZATION_CODE']:
                                resultLogin = login(data['IDP_IP'], data['IDP_PORT'], data['AUTHORIZATION_CODE'], access['REGISTRY'], access['TIME'], access['MAC'], access['DFP'])

                                if resultLogin['status'] == 'success' and resultLogin['token']:
                                    users[access['REGISTRY']] = resultLogin['token']

                                    message = getReauthenticate(users[access['REGISTRY']], access['REGISTRY'], access['IP_ADDRESS'], access['LATITUDE'], access['LONGITUDE'], access['MAC'], access['DFP'], access['OS'], access['VERSION_OS'], access['TIME'])
                                                        
                                    conn.sendall(message.encode('utf-8'))
                                    data = conn.recv(1024)
                                    response = data.decode('utf-8')
                                    print(response)
                                else:
                                    print('Failed to login on IDP server after reauthenticate')
                            else:
                                print("Access error on reauthentication")
                                break
                        else:
                            print(response)

                    case 'UPDATE_PASSWORD':
                        print("Password update is not available")
            print(f'Tempo médio de acesso: {(average_time/access_count)*1000} ms')

        conn.close()
        print("EFETUE A LIMPEZA DO BANCO DE DADOS ANTES DE REALIZAR O PRÓXIMO CENÁRIO")

    print('Closed connection')

def login(idpIp, idpPort, authorizationCode, registry, time, MAC, DFP):
    if idpIp and idpPort and authorizationCode:
        idpConnection = createIdpConnection(idpIp, int(idpPort))

        idpRequest = {
            'endpoint': 'authenticate',
            'registry': registry,
            'server_authorization_code': authorizationCode,
            'device_ioht_cert': '1234',
            'device_mac': MAC,
            'device_fp': DFP,
            'ppg_signal': ['1', '2', '3', '4', '5'],
            'ecg_signal': ['1', '2', '3', '4', '5'],
            'timestamp': time
        }

        idpConnection.sendall(json.dumps(idpRequest).encode('utf-8'))

        idpResponse = idpConnection.recv(4096)
        idpResponse = json.loads(idpResponse.decode('utf-8'))

        return idpResponse
    else:
        print('Missing idpIp, idpPort or authorizationCode from ZT server')
        return None

def createIdpConnection(idpIp, idpPort):
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        context = ssl.create_default_context(ssl.Purpose.SERVER_AUTH)
        context.check_hostname = False
        context.verify_mode = ssl.CERT_NONE
        conn = context.wrap_socket(sock, server_hostname=idpIp)

        conn.connect((idpIp, idpPort))
        return conn
    except Exception as e:
        print(e)
        return None
    

def getLogin(registry, ip, latitude, longitude, mac, dfp, os, versionOs, time):
    message = "LOGIN\n"
    message += "REGISTRY " + registry + "\n"
    message += "IP_ADDRESS " + ip + "\n"
    message += "LATITUDE " + latitude + "\n"
    message += "LONGITUDE " + longitude + "\n"
    message += "MAC " + mac + "\n"
    message += "DFP " + dfp + "\n"
    message += "OS " + os + "\n"
    message += "VERSION_OS " + versionOs + "\n"
    message += "TIME " + time + "\n"
    return message

def getAccess(resource, subResource, typeAction, token, ip, latitude, longitude, mac, dfp, os, versionOs, time):
    message = "ACCESS\n"
    message += "RESOURCE " + resource + "\n"
    message += "SUB_RESOURCE " + subResource + "\n"
    message += "TYPE_ACTION " + typeAction + "\n"
    message += "TOKEN " + token + "\n"
    message += "IP_ADDRESS " + ip + "\n"
    message += "LATITUDE " + latitude + "\n"
    message += "LONGITUDE " + longitude + "\n"
    message += "MAC " + mac + "\n"
    message += "DFP " + dfp + "\n"
    message += "OS " + os + "\n"
    message += "VERSION_OS " + versionOs + "\n"
    message += "TIME " + time + "\n"
    return message

def getReauthenticate(token, registry, ip, latitude, longitude, mac, dfp, os, versionOs, time):
    message = "REAUTHENTICATION\n"
    message += "TOKEN " + token + "\n"
    message += "REGISTRY " + registry + "\n"
    message += "IP_ADDRESS " + ip + "\n"
    message += "LATITUDE " + latitude + "\n"
    message += "LONGITUDE " + longitude + "\n"
    message += "MAC " + mac + "\n"
    message += "DFP " + dfp + "\n"
    message += "OS " + os + "\n"
    message += "VERSION_OS " + versionOs + "\n"
    message += "TIME " + time + "\n"
    return message

def getUpdatePassword(token, oldPassword, newPassword, ip, latitude, longitude, mac, dfp, os, versionOs, time):
    message = "UPDATE_PASSWORD\n"
    message += "TOKEN " + token + "\n"
    message += "OLD_PASSWORD " + oldPassword + "\n"
    message += "NEW_PASSWORD " + newPassword + "\n"
    message += "IP_ADDRESS " + ip + "\n"
    message += "LATITUDE " + latitude + "\n"
    message += "LONGITUDE " + longitude + "\n"
    message += "MAC " + mac + "\n"
    message += "DFP " + dfp + "\n"
    message += "OS " + os + "\n"
    message += "VERSION_OS " + versionOs + "\n"
    message += "TIME " + time + "\n"
    return message

def getFakeOperations():
    with open(os.path.dirname(os.path.abspath(__file__)) +"/scenarios/instance-C1.json") as f:
        clients = json.load(f)

        return json.dumps(clients[0]["OPERATIONS"])
    
if __name__ == '__main__':
    print("Start")
    startAccess()