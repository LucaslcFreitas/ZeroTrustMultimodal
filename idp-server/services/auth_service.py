import random
from validators.signal_validator import SignalValidator
from .token_manager import TokenManager
from services.store_service import StoreService

class AuthService:
    def __init__(self, token_manager: TokenManager, signal_validator: SignalValidator, store_service: StoreService):
        self.token_manager = token_manager
        self.signal_validator = signal_validator
        self.store_service = store_service

        #Fake accuracy
        self.base_accuracy = {
            'ppg': 0.85,
            'ecg': 0.92
        }

    def authenticate(self, authorization_code: str, registry: str, ppg_signal: list, ecg_signal: list, timestamp: str, device_iot_id: str, device_id: str, client_ip: str):
        # Buscar user id no bd
        user_id = self.store_service.getUserIdByRegistry(registry)
        if not user_id:
            return False, {'status': 'error', 'message': 'Unidentified user'}

        idRegLogin = self.store_service.validityRegLoginByAuthorizationCode(user_id, authorization_code)
        if not idRegLogin:
            return False, {'status': 'error', 'message': 'Invalid authorization code'}

        # Validação dos sinais biométricos
        validation_result = self.signal_validator.validate_signals(ppg_signal, ecg_signal)
        if not validation_result['valid']:
            return False, {"error": "Invalid signals", "details": validation_result}

        # Simulação de autenticação biométrica (substituir por CNN)
        auth_result = self._biometric_auth(user_id, ppg_signal, ecg_signal)

        # Store result authentication
        self.store_service.updateRegLogin(idRegLogin, auth_result['authenticated'], authorization_code, auth_result['accuracy']['ppg'], auth_result['accuracy']['ppg'])
        
        if not auth_result['authenticated']:
            return False, {"error": "Biometric authentication failed", "accuracy": auth_result['accuracy']}
 

        # Geração de tokens
        token = self.token_manager.generate_token(idRegLogin, user_id, device_id)

        
        return True, {
            "token": token,
            "accuracy": auth_result['accuracy'],
            "signal_quality": validation_result
        }
    
    def reauthenticate(self, authorization_code: str, registry: str, ppg_signal: list, ecg_signal: list, timestamp: str, device_iot_id: str, device_id: str, client_ip: str):
        # Buscar user id no bd
        user_id = self.store_service.getUserIdByRegistry(registry)
        if not user_id:
            return False, {'status': 'error', 'message': 'Unidentified user'}

        idRegLogin = self.store_service.validityRegLoginByAuthorizationCode(user_id, authorization_code)
        if not idRegLogin:
            return False, {'status': 'error', 'message': 'Invalid authorization code'}

        # Validação dos sinais biométricos
        validation_result = self.signal_validator.validate_signals(ppg_signal, ecg_signal)
        if not validation_result['valid']:
            return False, {"error": "Invalid signals", "details": validation_result}

        # Simulação de autenticação biométrica (substituir por CNN)
        auth_result = self._biometric_auth(user_id, ppg_signal, ecg_signal)

        # Store result authentication
        self.store_service.updateRegLogin(idRegLogin, auth_result['authenticated'], authorization_code, auth_result['accuracy']['ppg'], auth_result['accuracy']['ppg'])
        
        if not auth_result['authenticated']:
            return False, {"error": "Biometric authentication failed", "accuracy": auth_result['accuracy']}
        
        # Geração de tokens
        token = self.token_manager.generate_token(idRegLogin, user_id, device_id)
        
        return True, {
            "token": token,
            "accuracy": auth_result['accuracy'],
            "signal_quality": validation_result
        }

    def _biometric_auth(self, user_id: str, ppg_signal: list, ecg_signal: list):
        ppg_accuracy = self._calculate_accuracy('ppg', user_id, ppg_signal)
        ecg_accuracy = self._calculate_accuracy('ecg', user_id, ecg_signal)

        # Verificar se há pesos conforme otipo de sinal
        combined_accuracy = round((ppg_accuracy * 0.5 + ecg_accuracy * 0.5), 2)
        
        # Verificar mínimo para considerar autenticado
        return {
            'authenticated': combined_accuracy >= 0.8,
            'accuracy': {
                'ppg': ppg_accuracy,
                'ecg': ecg_accuracy,
                'combined': combined_accuracy
            }
        }

    def _calculate_accuracy(self, signal_type: str, user_id: str, signal_data: list):
        base = self.base_accuracy[signal_type]
        variation = min(0.1, len(signal_data)/1000)
        return round(base + random.uniform(-variation, variation), 2)