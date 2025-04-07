import socket
import ssl
import json
from services.auth_service import AuthService
from services.rate_limiter import RateLimiter
from services.token_manager import TokenManager
from core.request_handler import RequestHandler
import os
from validators.signal_validator import SignalValidator
import concurrent.futures
import logging

class IDPServer:
    config = {
        "ip_address": None,
        "port": None
    }
    def __init__(self):
        try:
            hostname = socket.gethostname()
            self.config['ip_address'] = socket.gethostbyname(hostname)
            self.config['port'] = int(os.getenv("PORT", 5000))
        except Exception as e:
            logging.error("Failed to configure server: " + str(e))
            exit()

        self.ssl_context = self._create_ssl_context()
        
        # Inicializa componentes
        self.token_manager = TokenManager()
        self.rate_limiter = RateLimiter()
        
        # Inicializa serviços
        signal_validator = SignalValidator()
        self.auth_service = AuthService(self.token_manager, signal_validator)

        # Carrega modelo CNN treinada
        

    def _create_ssl_context(self) -> ssl.SSLContext:
        # Configuração o contexto SSL para autenticação
        context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
        context.load_cert_chain(os.path.dirname(os.path.abspath(__file__)) + '/serveridp.crt', os.path.dirname(os.path.abspath(__file__)) + '/serveridp.key')
        context.verify_mode = ssl.CERT_OPTIONAL
        return context

    def _handle_client(self, secure_socket, address):
        # Manipula uma conexão de cliente
        try:
            # Recebe e processa a requisição
            raw_data = secure_socket.recv(4096).decode('utf-8')
            request_data = json.loads(raw_data)
            
            # Validação básica da requisição
            if 'endpoint' not in request_data:
                raise ValueError("Missing endpoint in request")
            
            server_authorization_code = request_data['server_authorization_code']
            if not server_authorization_code:
                secure_socket.send(json.dumps({
                    'status': 'error',
                    'message': 'Missing server authorization code'
                }).encode())
                return
            # TODO: Verificar código de autenticação zt
            
            # Autenticação do dispositivo iot via certificado
            device_iot_id = "device1" # self._authenticate_device(request_data)
            if not device_iot_id:
                secure_socket.send(json.dumps({
                    'status': 'error',
                    'message': 'Device IoT authentication failed'
                }).encode())
                return
            
            # Validação dos dispositivo utilizado
            device_id = "device1" # self._check_device(request_data)
            if not device_id:
                secure_socket.send(json.dumps({
                    'status': 'error',
                    'message': 'Check device failed'
                }).encode())
                return

            # Processamento pela camada de handler
            # TODO: Adicionar load do modelo CNN
            handler = RequestHandler(
                auth_service=self.auth_service,
                token_manager=self.token_manager,
                rate_limiter=self.rate_limiter
            )
            
            response = handler.handle_request(request_data, device_iot_id, device_id, address[0])
            secure_socket.send(json.dumps(response).encode('utf-8'))

        except json.JSONDecodeError:
            logging.error("Error: Invalid JSON format")
            error_msg = {'status': 'error', 'message': 'Invalid JSON format'}
            secure_socket.send(json.dumps(error_msg).encode('utf-8'))
        except Exception as e:
            logging.error("Server error: " + str(e))
            error_msg = {'status': 'error', 'message': 'Internal server error'}
            secure_socket.send(json.dumps(error_msg).encode('utf-8'))
        finally:
            secure_socket.close()

    def _authenticate_iot_device(self, request_data):
        # Valida certificado do dispositivo de captura de sinais
        try:
            cert = request_data['device_ioht_cert']
            if not cert:
                return None
                
            # Extrai identificador do certificado (simplificado)
            import hashlib
            cert_hash = hashlib.sha256(str(cert).encode()).hexdigest()
            
            # TODO: Verificar se o certificado está registrado
            return f"device_{cert_hash[:8]}"
        except Exception as e:
            logging.error("Device authentication error: " + str(e))
            return None
        
    def _check_device(self, request_data):
        # Valida certificado do dispositivo de captura de sinais
        try:
            MAC = request_data['device_mac']
            DFP = request_data['device_fp']

            if not MAC or not DFP:
                return None
            
            return f"device_{MAC}_{DFP}"
        except Exception as e:
            logging.error("Device authentication error: " + str(e))
            return None

    def start(self):
        # Inicia o servidor IDP
        server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server_socket.bind((self.config['ip_address'], self.config['port']))
        server_socket.listen()

        logging.info("IDP server started!")

        # logging.info(f'Waiting for connections at {self.config['ip_address']}:{self.config['port']}')

        with concurrent.futures.ThreadPoolExecutor() as executor:
            while True:
                try:
                    conn, addr = server_socket.accept()
                    logging.info(f'Connection received from {addr}')

                    secure_socket = self.ssl_context.wrap_socket(conn, server_side=True)

                    executor.submit(self._handle_client, secure_socket, addr)
                except Exception as e:
                    logging.error("Server error: " + e)
                    exit()