from datetime import datetime, timedelta
import hashlib
import json

class TokenManager:
        
    def generate_token(self, user_id, device_id):
        token_data = {
            'user_id': user_id,
            'device_id': device_id,
            'created_at': datetime.now().isoformat(),
            'expires_at': (datetime.now() + timedelta(hours=1)).isoformat()
        }
        access_token = hashlib.sha256(json.dumps(token_data).encode()).hexdigest()
        
        self._store_token(access_token, user_id, device_id)
        return access_token
        
    def revoke_token(self, token):
        # TODO: Implementar revocação de token no bd
        pass
    
    
    def _store_token(self, access_token, user_id, device_id):
        # TODO: Implementar armazenamento de token no bd
        pass