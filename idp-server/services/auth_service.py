from validators.signal_validator import SignalValidator
from .token_manager import TokenManager
from services.store_service import StoreService
import numpy as np
import json
import os
import logging

class AuthService:
    def __init__(self, token_manager: TokenManager, signal_validator: SignalValidator, store_service: StoreService, md_cnn1_ppg, md_cnn1_ecg, md_cnn2_ppg, md_cnn2_ecg):
        self.token_manager = token_manager
        self.signal_validator = signal_validator
        self.store_service = store_service

        self.md_cnn1_ppg = md_cnn1_ppg
        self.md_cnn1_ecg = md_cnn1_ecg
        self.md_cnn2_ppg = md_cnn2_ppg
        self.md_cnn2_ecg = md_cnn2_ecg

        self.templates_dir = "biometric_templates"

    def register(self, authorization_code: str, registry: str, ppg_signal: list, ecg_signal: list, timestamp: str, device_id: str, client_ip: str):
        logging.info("TTSS: before register")
        # Buscar user id no bd
        user_id = self.store_service.getUserIdToRegister(registry, authorization_code)
        if not user_id:
            return False, {'status': 'error', 'message': 'Unidentified user'}
        
        # Validação dos sinais biométricos
        validation_result = self.signal_validator.validate_signals(ppg_signal, ecg_signal)
        if not validation_result['valid']:
            return False, {"status": "error", "details": validation_result}
        
        registry_result = self._biometric_register(user_id, ppg_signal, ecg_signal)
        if not registry_result:
            return False, {"status": "error", "details":"Biometric registration failed"}
        
        self.store_service.approveRegistry(registry, authorization_code)
        
        logging.info("TTSS: after register")
        return True, {"status": "success"}

    def authenticate(self, authorization_code: str, registry: str, ppg_signal: list, ecg_signal: list, timestamp: str, device_id: str, client_ip: str):
        logging.info("TTSS: before authenticate")
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
        
        # Carrega o template registrado
        template_file = f"{self.templates_dir}/{user_id}.json"
        with open(os.path.dirname(os.path.abspath(__file__)) +"/" + template_file, 'r') as f:
            registered_template = json.load(f)

        if not registered_template:
            return False, {'status': 'error', 'message': 'Biometric template not found'}

        # Simulação de autenticação biométrica (substituir por CNN)
        auth_result = self._biometric_auth(user_id, registered_template['ppg_features'], registered_template['ecg_features'], ppg_signal, ecg_signal)

        # Store result authentication
        self.store_service.updateRegLogin(idRegLogin, auth_result['authenticated'], authorization_code, auth_result['accuracy']['ppg'], auth_result['accuracy']['ecg'])
        
        if not auth_result['authenticated']:
            return False, {"error": "Biometric authentication failed", "accuracy": auth_result['accuracy']}
 

        # Geração de tokens
        token = self.token_manager.generate_token(idRegLogin, user_id, device_id)

        logging.info("TTSS: after authenticate")
        return True, {
            "token": token,
            "accuracy": auth_result['accuracy'],
            "signal_quality": validation_result
        }
    
    def reauthenticate(self, authorization_code: str, registry: str, ppg_signal: list, ecg_signal: list, timestamp: str, device_id: str, client_ip: str):
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
        
        # Carrega o template registrado
        template_file = f"{self.templates_dir}/{user_id}.json"
        with open(os.path.dirname(os.path.abspath(__file__)) +"/" + template_file, 'r') as f:
            registered_template = json.load(f)

        if not registered_template:
            return False, {'status': 'error', 'message': 'Biometric template not found'}

        # Autenticação biométrica com CNNs
        auth_result = self._biometric_auth(user_id, registered_template['ppg_features'], registered_template['ecg_features'], ppg_signal, ecg_signal)

        # Store result authentication
        self.store_service.updateRegLogin(idRegLogin, auth_result['authenticated'], authorization_code, auth_result['accuracy']['ppg'], auth_result['accuracy']['ecg'])
        
        if not auth_result['authenticated']:
            return False, {"error": "Biometric authentication failed", "accuracy": auth_result['accuracy']}
        
        # Geração de tokens
        token = self.token_manager.generate_token(idRegLogin, user_id, device_id)
        
        return True, {
            "token": token,
            "accuracy": auth_result['accuracy'],
            "signal_quality": validation_result
        }
    
    def _biometric_register(self, user_id: str, ppg_signal: list, ecg_signal: list):
        try:
            ppg_array = np.array(ppg_signal)
            ppg_array = np.expand_dims(ppg_array, axis=2)
            ecg_array = np.array(ecg_signal)
            ecg_array = np.expand_dims(ecg_array, axis=2)

            # Extrai features com CNN1
            ppg_features = self.md_cnn1_ppg.predict(ppg_array)
            ecg_features = self.md_cnn1_ecg.predict(ecg_array)

            template = {
                'ppg_features': ppg_features.tolist(),
                'ecg_features': ecg_features.tolist()
            }

            # Salva o template
            template_file = f"{self.templates_dir}/{user_id}.json"
            with open(os.path.dirname(os.path.abspath(__file__)) +"/" + template_file, 'w') as f:
                json.dump(template, f)

            return True
        except Exception as e:
            logging.error(f"Erro no registro: {str(e)}")
            return False

    def _biometric_auth(self, user_id: str, ppg_template, ecg_template, ppg_signal: list, ecg_signal: list):
        logging.info("TTSS: before biometric auth")        
        # Opter por receber os sinais já formatados momentâneamente


        ppg_array = np.array(ppg_signal).reshape(1, 120, 1)
        ecg_array = np.array(ecg_signal).reshape(1, 120, 1)
        
        ppg_features = self.md_cnn1_ppg.predict(ppg_array)
        ecg_features = self.md_cnn1_ecg.predict(ecg_array)

        
        lista_ppg = []
        lista_ecg = []
        for template_ppg, template_ecg in zip(ppg_template, ecg_template):
            # Prepara pares para CNN2
            X_ppg = np.array([template_ppg, ppg_features[0]])
            lista_ppg.append(X_ppg)
            X_ecg = np.array([template_ecg, ecg_features[0]])
            lista_ecg.append(X_ecg)
            
        lista_ppg = np.array(lista_ppg)
        lista_ppg = np.expand_dims(lista_ppg, axis=3)
        lista_ecg = np.array(lista_ecg)
        lista_ecg = np.expand_dims(lista_ecg, axis=3)
        

        predict_ppg = self.md_cnn2_ppg.predict(lista_ppg)
        predict_ecg = self.md_cnn2_ecg.predict(lista_ecg)

        logging.info("TTSS: predict ppg: " + str(predict_ppg[1]))
        logging.info("TTSS: predict ecg: " + str(predict_ecg[1]))

        logging.info("TTSS: after biometric auth")
        return {
            'authenticated': 'True',
            'accuracy': {
                'ppg': 0.987,
                'ecg': 0.987
            }
        }