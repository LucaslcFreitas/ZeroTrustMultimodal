import socket
import ssl
import os
import json
import time

def startAccess():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
        HOST = "127.0.0.1"
        PORT = 5000

        
        try:
            context = ssl.create_default_context(ssl.Purpose.SERVER_AUTH)
            context.check_hostname = False
            context.verify_mode = ssl.CERT_NONE
            conn = context.wrap_socket(sock, server_hostname=HOST)

            conn.connect((HOST, PORT))
            print('Connected')

        except Exception as e:
            print(e)
            exit()


        message = json.dumps({
            'endpoint': 'authenticate',
            'registry': 'teste',
            'server_authorization_code': '1234',
            'device_ioht_cert': '1234',
            'device_mac': '123',
            'device_fp': '123',
            'ppg_signal': ['1', '2', '3', '4', '5'],
            'ecg_signal': ['1', '2', '3', '4', '5'],
            'timestamp': '2023-06-15 13:35:19.047062'
        })

        conn.sendall(message.encode('utf-8'))

        data = conn.recv(1024)
        response = data.decode('utf-8')

        print(response)

        conn.close()

    print('Closed connection')


if __name__ == '__main__':
    startAccess()