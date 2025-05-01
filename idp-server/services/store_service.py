import psycopg2
import os
import json
import datetime
import logging

class StoreService:
    config = {
        "dbHost": None,
        "dbPort": None,
        "dbDatabase": None,
        "dbUser": None,
        "dbPassword": None
    }
    def __init__(self):
        try:
            self.config['dbHost'] = os.getenv("DBHOST", "localhost")
            self.config['dbPort'] = int(os.getenv("DBPORT", 5432))
            self.config['dbDatabase'] = os.getenv("DBDATABASE", "zt-ehealth")
            self.config['dbUser'] = os.getenv("DBUSER", "postgres")
            self.config['dbPassword'] = os.getenv("DBPASSWORD")
            
            self.connection = None
            self.connect()
        except:
            exit()

    def connect(self) -> None:
        self.connection = psycopg2.connect(
            host=self.config["dbHost"],
            port=self.config["dbPort"],
            database=self.config["dbDatabase"],
            user=self.config["dbUser"],
            password=self.config["dbPassword"]
        )

    def closeConnection(self) -> None:
        if self.connection:
            self.connection.close()

    def getUserIdByRegistry(self, registry):
        if not self.connection:
            self.connect()

        try: 
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+registry+"' AND ativado = 'true'")
                result = cursor.fetchone()
                if result:
                    return result[0]
                return None

        except Exception as e:
            logging.info(e)
            return None
        
    def getUserIdToRegister(self, registry, authorization_code):
        if not self.connection:
            self.connect()

        try: 
            with self.connection.cursor() as cursor:
                logging.info("Select id to register")
                cursor.execute("SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+registry+"' AND \"codigoCriacao\" = '"+authorization_code+"' AND ativado = 'false'")
                result = cursor.fetchone()
                logging.info(result)
                if result:
                    return result[0]
                return None

        except Exception as e:
            logging.info(e)
            return None
        
    def approveRegistry(self, registry, authorization_code):
        if not self.connection:
            self.connect()

        try: 
            with self.connection.cursor() as cursor:
                cursor.execute("UPDATE \"zt-ehealth\".\"Usuario\" SET ativado = 'true' WHERE cpf = '"+registry+"' AND \"codigoCriacao\" = '"+authorization_code+"'")
                updated = cursor.rowcount

                self.connection.commit()
                if updated > 0:
                    return True
                return False

        except Exception as e:
            logging.info(e)
            return None
        
    def registerPassword(self, user_id, password_hash, timestamp, status):
        if not self.connection:
            self.connect()

        try: 
            with self.connection.cursor() as cursor:
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Senha\"(senha, \"idUsuario\", \"dataCriacao\", status) VALUES ('"+password_hash+"', '"+str(user_id)+"', '"+timestamp+"', '"+status+"')")
                updated = cursor.rowcount

                self.connection.commit()
                if updated > 0:
                    return True
                return False

        except Exception as e:
            logging.info(e)
            return None

    def validityRegLoginByAuthorizationCode(self, user_id, authorization_code, type_login):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT id FROM \"zt-ehealth\".\"RegLogin\" WHERE \"idUsuario\" = '"+str(user_id)+"' AND \"codigoAutorizacao\" = '"+authorization_code+"' AND \"tipoLogin\" = '"+type_login+"' AND completado = 'false'")
                result = cursor.fetchone()
                if result:
                    return result[0]
                return None

        except Exception as e:
            logging.info(e)
            return None
        
    def updateRegLoginForBiometric(self, id_reg_login, decision, authorization_code, score_ppg, score_ecg):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("UPDATE \"zt-ehealth\".\"RegLogin\" SET \"resultado\" = '"+str(decision)+"', \"completado\" = 'True', \"scorePPG\" = '"+str(score_ppg)+"', \"scoreECG\" = '"+str(score_ecg)+"' WHERE id = '"+str(id_reg_login)+"' AND \"codigoAutorizacao\" = '"+authorization_code+"'")
                updated = cursor.rowcount

                self.connection.commit()
                if updated > 0:
                    return True
                return False

        except Exception as e:
            logging.info(e)
            return None
        
    def updateRegLoginForPassword(self, id_reg_login, decision, authorization_code, id_password):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                if decision == 'Permitido':
                    cursor.execute("UPDATE \"zt-ehealth\".\"RegLogin\" SET \"resultado\" = '"+str(decision)+"', \"completado\" = 'True', \"idSenha\" = '"+str(id_password)+"' WHERE id = '"+str(id_reg_login)+"' AND \"codigoAutorizacao\" = '"+authorization_code+"'")
                else:
                    cursor.execute("UPDATE \"zt-ehealth\".\"RegLogin\" SET \"resultado\" = '"+str(decision)+"', \"completado\" = 'True' WHERE id = '"+str(id_reg_login)+"' AND \"codigoAutorizacao\" = '"+authorization_code+"'")
                updated = cursor.rowcount

                self.connection.commit()
                if updated > 0:
                    return True
                return False

        except Exception as e:
            logging.info(e)
            return None
        
    def checkLoginByPassword(self, idUser, password_hash):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT id FROM \"zt-ehealth\".\"Senha\" WHERE senha = '"+password_hash+"' AND \"idUsuario\" = '"+str(idUser)+"' AND status = 'Ativo'")
                result = cursor.fetchone()
                if result:
                    return result[0]
                return None
        except Exception as e:
            print(e)
            return None
        
    def updateAndRegisterToken(self, id_user, id_reg_login, token, validity, id_device):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("UPDATE \"zt-ehealth\".\"Token\" SET status='Inativo' WHERE \"idUsuario\" = '"+str(id_user)+"' AND status = 'Ativo'")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Token\"(\"idUsuario\", \"idRegLogin\", hash, validade, status, \"idDispositivo\") VALUES ('"+str(id_user)+"', '"+str(id_reg_login)+"', '"+token+"', '"+str(validity)+"', 'Ativo', '"+str(id_device)+"')")

                self.connection.commit()
                updated = cursor.rowcount
                if updated > 0:
                    return True
                return False

        except Exception as e:
            logging.info(e)
            return None
        
    def getDeviceIdByCode(self, authorization_code):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT \"idDispositivo\" FROM \"zt-ehealth\".\"RegLogin\" WHERE \"codigoAutorizacao\" = '"+authorization_code+"' AND completado = 'false'")
                result = cursor.fetchone()
                if result:
                    return result[0]
                return None

        except Exception as e:
            logging.info(e)
            return None
    
    def getDeviceIdByMac(self, MAC):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT id FROM \"zt-ehealth\".\"Dispositivo\" WHERE \"MAC\" = '"+MAC+"'")
                result = cursor.fetchone()
                if result:
                    return result[0]
                return None

        except Exception as e:
            logging.info(e)
            return None