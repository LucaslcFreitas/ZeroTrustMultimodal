import socket
import ssl
import os
import json
import time
import random
import logging

def startAccess():
    logging.info("antes do sleep")
    time.sleep(5)
    logging.info("depois do sleep")
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        logging.info("with socket")
        HOST = os.getenv("IP_ZERO_TRUST", '192.168.56.1')
        PORT = int(os.getenv("PORT_ZERO_TRUST", 5000))

        # Dados dos usuários
        tokens = {}
        passwords = {}

        # Operações de acesso
        logging.info("b operation_json")
        operations_json = os.getenv("OPERATIONS") 
        # operations_json = os.getenv("OPERATIONS", getFakeOperations())
        logging.info("a operation_json")

        # Dados de usuários
        users_json = os.getenv("USERS")
        # users_json = os.getenv("USERS", getFakeUsers())

        if operations_json and users_json:
            operations = json.loads(operations_json)
            users = json.loads(users_json)
        else:
            logging.info("No operations or users found")
            exit()

        # Sinais
        with open(os.path.dirname(os.path.abspath(__file__)) + '/signals.json', "r") as f:
            sig = json.load(f)
        ppg_signals = sig['ppg']
        ecg_signals = sig['ecg']

        if not ppg_signals or not ecg_signals:
            logging.info("No signals found")
            exit()
        
        try:
            logging.info("dados da conexão")
            # Conexão com o servidor Zero Trust (aceitando certificado ssl auto assinado)
            context = ssl.create_default_context(ssl.Purpose.SERVER_AUTH)
            context.check_hostname = False
            context.verify_mode = ssl.CERT_NONE
            conn = context.wrap_socket(sock, server_hostname=HOST)

            logging.info("antes da conexão")
            conn.connect((HOST, PORT))
            logging.info(f'Conected to {HOST}:{PORT}')

        except Exception as e:
            logging.error(e)
            exit()

        # average_time = 0.0
        # access_count = 0

        if operations:
            logging.info(len(operations))
            for access in operations:
                logging.info(access["TYPE"])
                match (access['TYPE']):
                    case 'REGISTRY':
                        user = getUser(users, access['REGISTRY'])
                        if not user:
                            logging.info('User not found')
                            break

                        message = getRegistry(access['REGISTRY'], user['TYPE_USER'], user['NAME'], user['POSITION'], user['DAYS_WORK'], user['START_WORKING_HOURS'], user['END_WORKING_HOURS'], access['IP_ADDRESS'], access['LATITUDE'], access['LONGITUDE'], access['MAC'], access['DFP'], access['OS'], access['VERSION_OS'], access['TIME'])

                        conn.sendall(message.encode('utf-8'))

                        data = conn.recv(1024)
                        response = data.decode('utf-8')
                        lines = response.strip().split('\n')
                        data = {}
                        data['RESULT'] = lines[0]
                        for line in lines[1:]:
                            key, value = line.split(' ', 1)
                            data[key] = value
                        if data['RESULT'] == 'AUTHORIZED_REGISTRY':
                            if data['IDP_IP'] and data['IDP_PORT'] and data['REGISTRY_CODE']:
                                ppgSigals, ecgSignals = getSignalsToRegister(ppg_signals, ecg_signals, user['SIGNAL_INDEX'])

                                resultRegistry = registry(data['IDP_IP'], data['IDP_PORT'], data['REGISTRY_CODE'], access['REGISTRY'], user['PASSWORD'], access['TIME'], access['MAC'], access['DFP'], ppgSigals, ecgSignals)
                                
                                if resultRegistry['status'] == 'success':
                                    print(tokens)
                                else:
                                    logging.info('Failed to registry on IDP server')
                                    print(resultRegistry)
                                    break
                            else:
                                logging.error("Registry error")
                                break
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
                            if data['IDP_IP'] and data['IDP_PORT'] and data['AUTHORIZATION_CODE'] and data['TYPE_LOGIN']:
                                if data['TYPE_LOGIN'] == 'password':
                                    resultLogin = login('authenticate', data['TYPE_LOGIN'], data['IDP_IP'], data['IDP_PORT'], data['AUTHORIZATION_CODE'], access['REGISTRY'], access['TIME'], access['MAC'], access['DFP'], access['PASSWORD'], None, None)
                                else:
                                    user = getUser(users, access['REGISTRY'])
                                    if not user:
                                        logging.error('User not found')
                                        break
                                    ppgSignal, ecgSignal = getSignalsToAuth(ppg_signals, ecg_signals, user['SIGNAL_INDEX'])
                                    if not ppgSignal or not ecgSignal:
                                        logging.error('User not found')
                                        break
                                    resultLogin = login('authenticate', data['TYPE_LOGIN'], data['IDP_IP'], data['IDP_PORT'], data['AUTHORIZATION_CODE'], access['REGISTRY'], access['TIME'], access['MAC'], access['DFP'], '', ppgSignal, ecgSignal)
                                
                                if resultLogin['status'] == 'success' and resultLogin['token']:
                                    tokens[access['REGISTRY']] = resultLogin['token']
                                    if data['TYPE_LOGIN'] == 'password':
                                        passwords[access['REGISTRY']] = access['PASSWORD']
                                    print(tokens)
                                else:
                                    logging.error('Failed to login on IDP server')
                                    print(resultLogin)
                            else:
                                logging.error("Login error")
                                break
                        elif access['REGISTRY'] in tokens and tokens[access['REGISTRY']] != None:
                            logging.error("Login error")
                            break
                    
                    case 'ACCESS':
                        message = getAccess(access['RESOURCE'], access['SUB_RESOURCE'], access['TYPE_ACTION'], tokens[access['REGISTRY']], access['IP_ADDRESS'], access['LATITUDE'], access['LONGITUDE'], access['MAC'], access['DFP'], access['OS'],  access['VERSION_OS'], access['TIME'])
                                                
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

                        # average_time += (time_end - time_start)
                        # access_count += 1

                        if data['RESULT'] == "AUTHENTICATION_REQUIRED":
                            logging.info("ACCESS - Authetication Required")
                            if data['IDP_IP'] and data['IDP_PORT'] and data['AUTHORIZATION_CODE'] and data['TYPE_LOGIN']:
                                resultLogin = login('authenticate', data['TYPE_LOGIN'], data['IDP_IP'], data['IDP_PORT'], data['AUTHORIZATION_CODE'], access['REGISTRY'], access['TIME'], access['MAC'], access['DFP'], passwords[access['REGISTRY']], None, None)

                                if resultLogin['status'] == 'success' and resultLogin['token']:
                                    tokens[access['REGISTRY']] = resultLogin['token']
                                    if data['TYPE_LOGIN'] == 'password':
                                        passwords[access['REGISTRY']] = access['PASSWORD']
                                    message = getAccess(access['RESOURCE'], access['SUB_RESOURCE'], access['TYPE_ACTION'], tokens[access['REGISTRY']], access['IP_ADDRESS'], access['LATITUDE'], access['LONGITUDE'], access['MAC'], access['DFP'], access['OS'], access['VERSION_OS'], access['TIME'])
                                
                                    conn.sendall(message.encode('utf-8'))
                                    data = conn.recv(1024)
                                    response = data.decode('utf-8')
                                    print(response)
                                else:
                                    logging.error('Failed to login on IDP server after access')
                            else:
                                logging.error("Access error on authentication")
                                break

                        if data['RESULT'] == "REAUTHENTICATION_REQUIRED" and access['REAUTHENTICATE']:
                            logging.info("ACCESS - ReAuthetication Required")
                            if data['IDP_IP'] and data['IDP_PORT'] and data['AUTHORIZATION_CODE'] and data['TYPE_LOGIN']:
                                user = getUser(users, access['REGISTRY'])
                                if not user:
                                    print('User not found')
                                    break
                                ppgSignal, ecgSignal = getSignalsToAuth(ppg_signals, ecg_signals, user['SIGNAL_INDEX'])
                                if not ppgSignal or not ecgSignal:
                                    print('User not found')
                                    break
                                resultLogin = login('reauthenticate', data['TYPE_LOGIN'], data['IDP_IP'], data['IDP_PORT'], data['AUTHORIZATION_CODE'], access['REGISTRY'], access['TIME'], access['MAC'], access['DFP'], passwords[access['REGISTRY']], ppgSignal, ecgSignal)

                                if resultLogin['status'] == 'success' and resultLogin['token']:
                                    logging.info('Reauthenticate success from IDP')
                                    tokens[access['REGISTRY']] = resultLogin['token']

                                    message = getReauthenticate(tokens[access['REGISTRY']], access['REGISTRY'], access['IP_ADDRESS'], access['LATITUDE'], access['LONGITUDE'], access['MAC'], access['DFP'], access['OS'], access['VERSION_OS'], access['TIME'])
                                                        
                                    conn.sendall(message.encode('utf-8'))
                                    data = conn.recv(1024)
                                    response = data.decode('utf-8')
                                    logging.info("Reauthenticate after ZT")
                                    print(response)
                                else:
                                    logging.error('Failed to login on IDP server after reauthenticate')
                                    print(resultLogin)
                            else:
                                logging.error("Access error on reauthentication")
                                break
                        else:
                            print(response)

                    case 'CHANGE_SIGNALS':
                        user = getUser(users, access['REGISTRY'])
                        print(user)
                        if not user:
                            print('User not found')
                            break
                        randomIndex = random.randint(access['MIN'], access['MAX'])
                        while randomIndex == user['SIGNAL_INDEX']:
                            randomIndex = random.randint(access['MIN'], access['MAX'])
                        user['SIGNAL_INDEX'] = randomIndex
                        print(user)


                    case 'UPDATE_PASSWORD':
                        logging.info("Password update is not available")
            # print(f'Tempo médio de acesso: {(average_time/access_count)*1000} ms')

        conn.close()
        logging.info("EFETUE A LIMPEZA DO BANCO DE DADOS ANTES DE REALIZAR O PRÓXIMO CENÁRIO")

    logging.info('Closed connection')

def registry(idpIp, idpPort, registryCode, registry, password, time, MAC, DFP, ppgSignal, ecgSignal):
    if idpIp and idpPort and registryCode:
        idpConnection = createIdpConnection(idpIp, int(idpPort))

        idpRequest = {
            'endpoint': 'register',
            'registry': registry,
            'server_authorization_code': registryCode,
            'password': password,
            'device_mac': MAC,
            'device_fp': DFP,
            'ppg_signal': ppgSignal,
            'ecg_signal': ecgSignal,
            'timestamp': time
        }

        idpConnection.sendall((json.dumps(idpRequest) + "\0").encode('utf-8'))

        idpResponse = idpConnection.recv(4096)
        idpResponse = json.loads(idpResponse.decode('utf-8'))

        return idpResponse
    else:
        logging.error('Missing idpIp, idpPort or authorizationCode from ZT server')
        return None

def login(endpoint, typeLogin, idpIp, idpPort, authorizationCode, registry, time, MAC, DFP, password, ppgSignal, ecgSignal):
    if idpIp and idpPort and authorizationCode:
        idpConnection = createIdpConnection(idpIp, int(idpPort))

        if typeLogin == 'biometric':
            idpRequest = {
                'endpoint': endpoint,
                'type_login': typeLogin,
                'registry': registry,
                'server_authorization_code': authorizationCode,
                'device_mac': MAC,
                'device_fp': DFP,
                'ppg_signal': ppgSignal,
                'ecg_signal': ecgSignal,
                'timestamp': time
            }
        else:
            idpRequest = {
                'endpoint': endpoint,
                'type_login': typeLogin,
                'registry': registry,
                'server_authorization_code': authorizationCode,
                'device_mac': MAC,
                'device_fp': DFP,
                'password': password,
                'timestamp': time
            }

        idpConnection.sendall((json.dumps(idpRequest) + "\0").encode('utf-8'))

        idpResponse = idpConnection.recv(4096)
        idpResponse = json.loads(idpResponse.decode('utf-8'))

        return idpResponse
    else:
        logging.error('Missing idpIp, idpPort or authorizationCode from ZT server')
        return None

def createIdpConnection(idpIp, idpPort):
    # idpIp = '192.168.1.76'
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
    
def getUser(users, registry):
    for user in users:
        if user['REGISTRY'] == registry:
            return user
    return None

def getSignalsToRegister(ppgSignal, ecgSignal, index):
    ppgReg = []
    ecgReg = []

    for ppg in ppgSignal:
        if ppg['user'] == index:
            beats = random.sample(range(0, len(ppg['signals'])-1), 6)
            for beat in beats:
                ppgReg.append(ppg['signals'][beat])
            break
    for ecg in ecgSignal:
        if ecg['user'] == index:
            beats = random.sample(range(0, len(ecg['signals'])-1), 6)
            for beat in beats:
                ecgReg.append(ecg['signals'][beat])
            break
    return ppgReg, ecgReg

def getSignalsToAuth(ppgSignal, ecgSignal, index):
    auxPPG= []
    auxECG = []

    for ppg in ppgSignal:
        if ppg['user'] == index:
            beats = random.sample(range(0, len(ppg['signals'])-1), 2)
            for beat in beats:
                auxPPG.append(ppg['signals'][beat])
            break
    for ecg in ecgSignal:
        if ecg['user'] == index:
            beats = random.sample(range(0, len(ecg['signals'])-1), 2)
            for beat in beats:
                auxECG.append(ecg['signals'][beat])
            break
    if not auxPPG or not auxECG:
        return None, None

    return auxPPG, auxECG
    

def getRegistry(registry, typeUser, name, position, daysWork, startWorkingHours, endWorkingHours, ip, latitude, longitude, mac, dfp, os, versionOs, time):
    if typeUser == 'Profissional':
        message = "REGISTRY\n"
        message += "REGISTRY " + registry + "\n"
        message += "TYPE_USER " + typeUser + "\n"
        message += "NAME " + name + "\n"
        message += "POSITION " + position + "\n"
        message += "DAYS_WORK " + daysWork + "\n"
        message += "START_WORKING_HOURS " + startWorkingHours + "\n"
        message += "END_WORKING_HOURS " + endWorkingHours + "\n"
        message += "IP_ADDRESS " + ip + "\n"
        message += "LATITUDE " + latitude + "\n"
        message += "LONGITUDE " + longitude + "\n"
        message += "MAC " + mac + "\n"
        message += "DFP " + dfp + "\n"
        message += "OS " + os + "\n"
        message += "VERSION_OS " + versionOs + "\n"
        message += "TIME " + time + "\n"
    else:
        message = "REGISTRY\n"
        message += "REGISTRY " + registry + "\n"
        message += "TYPE_USER " + typeUser + "\n"
        message += "NAME " + name + "\n"
        message += "IP_ADDRESS " + ip + "\n"
        message += "LATITUDE " + latitude + "\n"
        message += "LONGITUDE " + longitude + "\n"
        message += "MAC " + mac + "\n"
        message += "DFP " + dfp + "\n"
        message += "OS " + os + "\n"
        message += "VERSION_OS " + versionOs + "\n"
        message += "TIME " + time + "\n"
    return message

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

# def getFakeOperations():
#     with open(os.path.dirname(os.path.abspath(__file__)) +"/test.json") as f:
#         clients = json.load(f)

#         return json.dumps(clients[0]["OPERATIONS"])

# def getFakeUsers():
#     with open(os.path.dirname(os.path.abspath(__file__)) +"/test.json") as f:
#         clients = json.load(f)

#         return json.dumps(clients[0]["USERS"])
    
if __name__ == '__main__':
    print("Start")
    startAccess()