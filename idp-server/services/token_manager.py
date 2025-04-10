from datetime import datetime, timedelta
from services.store_service import StoreService
import hashlib
import json

class TokenManager:
    def __init__(self, store_service: StoreService):
        self.store_service = store_service
        
    def generate_token(self, id_reg_login, user_id, device_id):
        expire_at = (datetime.now() + timedelta(hours=1)).isoformat()

        token_data = {
            'user_id': user_id,
            'device_id': device_id,
            'created_at': datetime.now().isoformat(),
            'expires_at': expire_at
        }
        access_token = hashlib.sha256(json.dumps(token_data).encode()).hexdigest()

        # Store token
        self.store_service.updateAndRegisterToken(user_id, id_reg_login, access_token, expire_at, device_id)
        return access_token
        
    def revoke_token(self, token):
        # TODO: Implementar revocação de token no bd
        pass
    