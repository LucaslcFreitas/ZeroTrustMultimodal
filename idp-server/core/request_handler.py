from typing import Dict
from services.auth_service import AuthService
from services.rate_limiter import RateLimiter
from services.token_manager import TokenManager
from services.store_service import StoreService
from validators.token_validator import TokenValidator
from validators.auth_validator import AuthValidator
from validators.reauth_validator import ReauthValidator
from validators.register_validator import RegisterValidator
import logging

class RequestHandler:
    def __init__(self, auth_service: AuthService, token_manager: TokenManager,
                 rate_limiter: RateLimiter):
        self.auth_service = auth_service
        self.token_manager = token_manager
        self.rate_limiter = rate_limiter
        self.validators = {
            'register': RegisterValidator(),
            'authenticate': AuthValidator(),
            'reauthenticate': ReauthValidator(),
            'logout': TokenValidator()
        }

    def handle_request(self, request_data: Dict, device_id: str, client_ip: str) -> Dict:
        endpoint = request_data.get('endpoint')
        
        # Validação do endpoint
        if endpoint not in self.validators:
            return {'status': 'error', 'message': 'Invalid endpoint'}
        
        # Validação da requisição
        is_valid, error = self.validators[endpoint].validate(request_data)
        if not is_valid:
            return {'status': 'error', 'message': error}
        
        # Rate limiting
        if not self.rate_limiter.check_limit(client_ip, endpoint, request_data['timestamp']):
            return {'status': 'error', 'message': 'Too many requests'}
        
        # handler do endpoint
        handler = getattr(self, f'_handle_{endpoint}', None)
        if not handler:
            return {'status': 'error', 'message': 'Endpoint not implemented'}
        
        return handler(request_data, device_id, client_ip)
    
    def _handle_register(self, request_data: Dict, device_id: str, client_ip: str) -> Dict:
        result, data = self.auth_service.register(
            request_data['server_authorization_code'],
            request_data['registry'],
            request_data['ppg_signal'],
            request_data['ecg_signal'],
            request_data['timestamp'],
            device_id,
            client_ip
        )

        if result:
            return {'status': 'success'}
        return {'status': 'error', **data}

    def _handle_authenticate(self, request_data: Dict, device_id: str, client_ip: str) -> Dict:
        # Processa autenticação
        result, data = self.auth_service.authenticate(
            request_data['server_authorization_code'],
            request_data['registry'],
            request_data['ppg_signal'],
            request_data['ecg_signal'],
            request_data['timestamp'],
            device_id,
            client_ip
        )
        
        if result:
            return {
                'status': 'success',
                'token': data['token'],
                'accuracy': data['accuracy']
            }
        return {'status': 'error', **data}
    
    def _handle_reauthenticate(self, request_data: Dict, device_id: str, client_ip: str) -> Dict:
        # Processa reautenticação
        result, data = self.auth_service.reauthenticate(
            request_data['server_authorization_code'],
            request_data['registry'],
            request_data['ppg_signal'],
            request_data['ecg_signal'],
            request_data['timestamp'],
            device_id,
            client_ip
        )
        
        if result:
            return {
                'status': 'success',
                'token': data['token'],
                'accuracy': data['accuracy']
            }
        return {'status': 'error', **data}

    def _handle_logout(self, request_data: Dict, device_id: str, client_ip: str) -> Dict:
        # Processa logout
        self.token_manager.revoke_token(request_data['token'])
        return {'status': 'success', 'message': 'Logged out'}