from .base_validator import BaseValidator

class AuthValidator(BaseValidator):
    REQUIRED_FIELDS = ['type_login', 'registry', 'server_authorization_code', 'device_mac', 'device_fp', 'ppg_signal', 'ecg_signal', 'timestamp']
    
    def validate(self, data):
        if 'type_login' in data and data['type_login'] == 'biometric':
            self.REQUIRED_FIELDS = ['registry', 'server_authorization_code', 'device_mac', 'device_fp', 'ppg_signal', 'ecg_signal', 'timestamp']
        else:
            self.REQUIRED_FIELDS = ['registry', 'server_authorization_code', 'device_mac', 'device_fp', 'password', 'timestamp']

        is_valid, error = super().validate(data)
        if not is_valid:
            return False, error
            
        if 'type_login' in data and data['type_login'] == 'biometric':
            # Validações específicas para autenticação
            # TODO: Verificar quantidade de sinais
            if len(data['ppg_signal']) < 1 or len(data['ecg_signal']) < 1:
                return False, "Signals too short"
            
        return True, None