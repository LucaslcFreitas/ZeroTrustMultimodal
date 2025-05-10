from validators.signal_validator import SignalValidator
from .token_manager import TokenManager
from services.store_service import StoreService
import numpy as np
import json
import os
import logging
import random
import hashlib
from keras import activations
import tensorflow as tf

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

    def register(self, authorization_code: str, registry: str, password:str, ppg_signal: list, ecg_signal: list, timestamp: str, device_id: str, client_ip: str):
        # Buscar user id no bd
        user_id = self.store_service.getUserIdToRegister(registry, authorization_code)
        if not user_id:
            return False, {'status': 'error', 'message': 'Unidentified user'}
        
        # Validação dos sinais biométricos
        validation_result = self.signal_validator.validate_signals(ppg_signal, ecg_signal)
        if not validation_result['valid']:
            return False, {"status": "error", "details": validation_result}
        
        registry_pwd_result = self._password_register(user_id, password, timestamp)
        if not registry_pwd_result:
            return False, {"status": "error", "details":"Password registration failed"}
        
        registry_result = self._biometric_register(user_id, ppg_signal, ecg_signal)
        if not registry_result:
            return False, {"status": "error", "details":"Biometric registration failed"}
        
        self.store_service.approveRegistry(registry, authorization_code)
        
        return True, {"status": "success"}

    def authenticate(self, authorization_code: str, type_login: str, registry: str, password: str, ppg_signal: list, ecg_signal: list, timestamp: str, device_id: str, client_ip: str):
        # Buscar user id no bd
        user_id = self.store_service.getUserIdByRegistry(registry)
        if not user_id:
            return False, {'status': 'error', 'message': 'Unidentified user'}

        idRegLogin = self.store_service.validityRegLoginByAuthorizationCode(user_id, authorization_code, type_login)
        if not idRegLogin:
            return False, {'status': 'error', 'message': 'Invalid authorization code or type of login'}
        
        #Autenticação por biometria
        auth_result = None
        if type_login == 'biometric':
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
            updated = self.store_service.updateRegLoginForBiometric(idRegLogin, auth_result['authenticated'], authorization_code, auth_result['accuracy']['ppg'], auth_result['accuracy']['ecg'])

            if not updated:
                return False, {"error": "Biometric authentication failed"}
            
            if auth_result['authenticated'] == 'Negado':
                return False, {"error": "Biometric authentication failed", "accuracy": auth_result['accuracy']}
        else:
            # Autenticação por senha
            auth_result = self._password_auth(user_id, password)

            # Store result authentication
            updated = self.store_service.updateRegLoginForPassword(idRegLogin, auth_result['authenticated'], authorization_code, auth_result['login_id'])

            if not updated:
                return False, {"error": "Password authentication failed"}
            
            if auth_result['authenticated'] == 'Negado':
                return False, {"error": "Password authentication failed"}
 

        # Geração de tokens
        token = self.token_manager.generate_token(idRegLogin, user_id, device_id)

        if type_login == 'biometric':
            return True, {
                "token": token,
                "accuracy": auth_result['accuracy']
            }
        return True, {
            "token": token
        }
    
    def reauthenticate(self, authorization_code: str, registry: str, ppg_signal: list, ecg_signal: list, timestamp: str, device_id: str, client_ip: str):
        # Buscar user id no bd
        user_id = self.store_service.getUserIdByRegistry(registry)
        if not user_id:
            return False, {'status': 'error', 'message': 'Unidentified user'}

        idRegLogin = self.store_service.validityRegLoginByAuthorizationCode(user_id, authorization_code, 'biometric')
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
        self.store_service.updateRegLoginForBiometric(idRegLogin, auth_result['authenticated'], authorization_code, auth_result['accuracy']['ppg'], auth_result['accuracy']['ecg'])
        
        if auth_result['authenticated'] == 'Negado':
            return False, {"error": "Biometric authentication failed", "accuracy": auth_result['accuracy']}
        
        # Geração de tokens
        token = self.token_manager.generate_token(idRegLogin, user_id, device_id)
        
        return True, {
            "token": token,
            "accuracy": auth_result['accuracy']
        }
    
    def _password_register(self, user_id: str, password: str, timestamp: str):
        pwdToken = hashlib.sha256(str(password).encode('utf-8')).hexdigest()
        return self.store_service.registerPassword(user_id, pwdToken, timestamp, 'Ativo')

    
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
        
    def _password_auth(self, user_id: str, password: str):
        pwd_token = hashlib.sha256(str(password).encode('utf-8')).hexdigest()

        login_id = self.store_service.checkLoginByPassword(user_id, pwd_token)
        return {
            'authenticated': 'Permitido' if login_id else 'Negado',
            'login_id': login_id
        }

    def _biometric_auth(self, user_id: str, ppg_template, ecg_template, ppg_signal: list, ecg_signal: list):     
        # Opter por receber os sinais já formatados momentâneamente

        ppg_array = np.array(ppg_signal)
        ppg_array = np.expand_dims(ppg_array, axis=2)
        ecg_array = np.array(ecg_signal)
        ecg_array = np.expand_dims(ecg_array, axis=2)
        
        ppg_features = self.md_cnn1_ppg.predict(ppg_array)
        ecg_features = self.md_cnn1_ecg.predict(ecg_array)

        
        lista_ppg = []
        lista_ecg = []
        for template_ppg, template_ecg in zip(ppg_template, ecg_template):
            # Prepara pares para CNN2
            for i in range(2):
                X_ppg = np.array([template_ppg, ppg_features[i]])
                lista_ppg.append(X_ppg)
                X_ecg = np.array([template_ecg, ecg_features[i]])
                lista_ecg.append(X_ecg)
            
        lista_ppg = np.array(lista_ppg)
        lista_ppg = np.expand_dims(lista_ppg, axis=3)
        lista_ecg = np.array(lista_ecg)
        lista_ecg = np.expand_dims(lista_ecg, axis=3)
        

        predict_ppg = self.md_cnn2_ppg.predict(lista_ppg)
        predict_ecg = self.md_cnn2_ecg.predict(lista_ecg)

        logging.info("Predict ppg: " + str(predict_ppg[1]))
        logging.info("Predict ecg: " + str(predict_ecg[1]))

        ppg_sof = activations.softmax(tf.convert_to_tensor(predict_ppg)).numpy()
        ecg_sof = activations.softmax(tf.convert_to_tensor(predict_ecg)).numpy()

        ppg_result = ppg_sof[0][1] + ppg_sof[1][1] + ppg_sof[2][1] + ppg_sof[3][1] + ppg_sof[4][1] + ppg_sof[5][1] + ppg_sof[6][1] + ppg_sof[7][1] + ppg_sof[8][1] + ppg_sof[9][1] + ppg_sof[10][1] + ppg_sof[11][1]
        ppg_result = (ppg_result / 12) * 100
        ecg_result = ecg_sof[0][1] + ecg_sof[1][1] + ecg_sof[2][1] + ecg_sof[3][1] + ecg_sof[4][1] + ecg_sof[5][1] + ecg_sof[6][1] + ecg_sof[7][1] + ecg_sof[8][1] + ecg_sof[9][1] + ecg_sof[10][1] + ecg_sof[11][1]
        ecg_result = (ecg_result / 12) * 100

        logging.info("PPG: " + str(ppg_result))
        logging.info("ECG: " + str(ecg_result))

        # fake_ppg = self.generate_fake_precision()
        # fake_ecg = self.generate_fake_precision()
        # logging.info("Fake ppg: " + str(fake_ppg))
        # logging.info("Fake ecg: " + str(fake_ecg))

        return {
            'authenticated': 'Permitido' if self._is_authenticated(ppg_result, ecg_result) else 'Negado',
            'accuracy': {
                'ppg': ppg_result,
                'ecg': ecg_result
            }
        }
        # return {
        #     'authenticated': 'Permitido' if self._is_authenticated(fake_ppg, fake_ecg) else 'Negado',
        #     'accuracy': {
        #         'ppg': ppg_result,
        #         'ecg': ecg_result
        #     }
        # }
    
    def _is_authenticated(self, ppg_score, ecg_score):
        if ppg_score > 70 or ecg_score > 70:
            return True
        average = (ppg_score + ecg_score) / 2
        if average > 75:
            return True
        return False
    
    def generate_fake_precision(self):
        if random.random() < 0.80:
            return round(random.uniform(80, 100), 2)
        else:
            return round(random.uniform(75, 80), 2)