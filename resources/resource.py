import os
import socket
import threading

def get_ip():
    hostname = socket.gethostname()
    return socket.gethostbyname(hostname)

def start_resource(name, port):
    ip = get_ip()
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.bind((ip, port))
    sock.listen()

    while True:
        conn, addr = sock.accept()
        print(f'Connection received from {addr}')

        t = threading.Thread(target=handle_conection, args=(conn, name))
        t.start()

def handle_conection(conn, resourceName):
    response = resourceName
    conn.sendall(response.encode('utf-8'))
    conn.close()


if __name__ == '__main__':
    resource_name = os.getenv("RESOURCE_NAME", "Recurso Desconhecido")
    port = int(os.getenv("PORT", 5000))

    start_resource(resource_name, port)