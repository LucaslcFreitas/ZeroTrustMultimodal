import socket
import ssl
import json
from services.auth_service import AuthService
from services.rate_limiter import RateLimiter
from services.token_manager import TokenManager
from core.request_handler import RequestHandler
from services.store_service import StoreService
import os
from validators.signal_validator import SignalValidator
import concurrent.futures
import logging
from ml_models.load_models import loadModel

class IDPServer:
    config = {
        "ip_address": None,
        "port": None
    }
    def __init__(self):
        try:
            hostname = socket.gethostname()
            self.config['ip_address'] = socket.gethostbyname(hostname)
            self.config['port'] = int(os.getenv("PORT", 5001))
        except Exception as e:
            logging.error("Failed to configure server: " + str(e))
            exit()

        self.ssl_context = self._create_ssl_context()

        # Carrega modelos
        self.model_cnn1_ppg = loadModel('ppg', 'CNN1')
        self.model_cnn1_ecg = loadModel('ecg', 'CNN1')
        self.model_cnn2_ppg = loadModel('ppg', 'CNN2')
        self.model_cnn2_ecg = loadModel('ecg', 'CNN2')

        # Inicializa o store
        self.store_service= StoreService()
        
        # Inicializa componentes
        self.token_manager = TokenManager(self.store_service)
        self.rate_limiter = RateLimiter()
        
        # Inicializa serviços
        signal_validator = SignalValidator()
        self.auth_service = AuthService(self.token_manager, signal_validator, self.store_service, self.model_cnn1_ppg, self.model_cnn1_ecg, self.model_cnn2_ppg, self.model_cnn2_ecg)
        

    def _create_ssl_context(self) -> ssl.SSLContext:
        # Configuração o contexto SSL para autenticação
        context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
        context.load_cert_chain(os.path.dirname(os.path.abspath(__file__)) + '/serveridp.crt', os.path.dirname(os.path.abspath(__file__)) + '/serveridp.key')
        context.verify_mode = ssl.CERT_OPTIONAL
        return context

    def _handle_client(self, secure_socket, address):
        logging.info("TTSS: before handle client")
        # Manipula uma conexão de cliente
        try:
            raw_data = ''
            while True:
                aux = secure_socket.recv(16384).decode('utf-8')
                if not aux:
                    break
                raw_data += aux
                if '\0' in raw_data:
                    raw_data = raw_data.split('\0')[0] 
                    break
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
            
            # Validação dos dispositivo utilizado
            device_id = ""
            if request_data['endpoint'] != 'register':
                device_id = self.store_service.getDeviceIdByCode(server_authorization_code)
            else:
                if request_data['device_mac']:
                    device_id = self.store_service.getDeviceIdByMac(request_data['device_mac'])
            if not device_id:
                secure_socket.send(json.dumps({
                    'status': 'error',
                    'message': 'Check device failed'
                }).encode())
                return

            # Processamento pela camada de handler
            handler = RequestHandler(
                auth_service=self.auth_service,
                token_manager=self.token_manager,
                rate_limiter=self.rate_limiter
            )
            
            response = handler.handle_request(request_data, device_id, address[0])
            secure_socket.send(json.dumps(response).encode('utf-8'))

        except json.JSONDecodeError as e:
            logging.error(raw_data)
            logging.error("Invalid JSON format: "+ str(e))
            error_msg = {'status': 'error', 'message': 'Invalid JSON format'}
            secure_socket.send(json.dumps(error_msg).encode('utf-8'))
        except Exception as e:
            logging.error("Server error: " + str(e))
            error_msg = {'status': 'error', 'message': 'Internal server error'}
            secure_socket.send(json.dumps(error_msg).encode('utf-8'))
        finally:
            secure_socket.close()
        logging.info("TTSS: after handle client")

    def start(self):
        # Inicia o servidor IDP
        server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server_socket.bind((self.config['ip_address'], self.config['port']))
        server_socket.listen()

        logging.info("IDP server started!")

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