from .base_validator import BaseValidator

class RegisterValidator(BaseValidator):
    REQUIRED_FIELDS = ['registry', 'password', 'server_authorization_code', 'device_mac', 'device_fp', 'ppg_signal', 'ecg_signal', 'timestamp']
    
    def validate(self, data):
        is_valid, error = super().validate(data)
        if not is_valid:
            return False, error
            
        # Validações específicas para autenticação
        # TODO: Verificar quantidade de sinais
        if len(data['ppg_signal']) < 1 or len(data['ecg_signal']) < 1:
            return False, "Signals too short"
            
        return True, None