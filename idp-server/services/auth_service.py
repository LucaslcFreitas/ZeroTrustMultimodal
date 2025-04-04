import random
from validators.signal_validator import SignalValidator
from .token_manager import TokenManager

class AuthService:
    def __init__(self, token_manager: TokenManager, signal_validator: SignalValidator):
        self.token_manager = token_manager
        self.signal_validator = signal_validator

        #Fake accuracy
        self.base_accuracy = {
            'ppg': 0.85,
            'ecg': 0.92
        }

    def authenticate(self, registry: str, ppg_signal: list, ecg_signal: list, timestamp: str, device_iot_id: str, device_id: str, client_ip: str):
        # Buscar user id no bd
        user_id = registry

        # Validação dos sinais biométricos
        validation_result = self.signal_validator.validate_signals(ppg_signal, ecg_signal)
        if not validation_result['valid']:
            return False, {"error": "Invalid signals", "details": validation_result}

        # Simulação de autenticação biométrica (substituir por CNN)
        auth_result = self._biometric_auth(user_id, ppg_signal, ecg_signal)
        
        if not auth_result['authenticated']:
            return False, {"error": "Biometric authentication failed", "accuracy": auth_result['accuracy']}

        # Geração de tokens
        token = self.token_manager.generate_token(user_id, device_id)

        # TODO: Armazenar resultado no bd
        
        return True, {
            "token": token,
            "accuracy": auth_result['accuracy'],
            "signal_quality": validation_result
        }
    
    def reauthenticate(self, registry: str, ppg_signal: list, ecg_signal: list, timestamp: str, device_iot_id: str, device_id: str, client_ip: str):
        # Buscar user id no bd
        user_id = registry

        # Validação dos sinais biométricos
        validation_result = self.signal_validator.validate_signals(ppg_signal, ecg_signal)
        if not validation_result['valid']:
            return False, {"error": "Invalid signals", "details": validation_result}

        # Simulação de autenticação biométrica (substituir por CNN)
        auth_result = self._biometric_auth(user_id, ppg_signal, ecg_signal)
        
        if not auth_result['authenticated']:
            return False, {"error": "Biometric authentication failed", "accuracy": auth_result['accuracy']}
        
        # TODO: Invalidar token, caso tenho algum ativo
        
        # Geração de tokens
        token = self.token_manager.generate_token(user_id, device_id)

        # TODO: Armazenar resultado no bd
        
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