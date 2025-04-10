import psycopg2
import os
import json
import datetime

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
                cursor.execute("SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+registry+"'")
                result = cursor.fetchone()
                if result:
                    return result[0]
                return None

        except Exception as e:
            print(e)
            return None

    def validityRegLoginByAuthorizationCode(self, userId, authorizationCode):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT id FROM \"zt-ehealth\".\"RegLogin\" WHERE \"idUsuario\" = '"+str(userId)+"' AND \"codigoAutorizacao\" = '"+authorizationCode+"' AND completado = 'false'")
                result = cursor.fetchone()
                if result:
                    return result[0]
                return None

        except Exception as e:
            print(e)
            return None
        
    def updateRegLogin(self, idRegLogin, decision, authorizationCode, scorePPG, scoreECG):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("UPDATE \"zt-ehealth\".\"RegLogin\" SET resultado = '"+str(decision)+"', completado='True', \"scorePPG\" = '"+str(scorePPG)+"', \"scoreECG\" = '"+str(scoreECG)+"' WHERE id = '"+str(idRegLogin)+"' AND \"codigoAutorizacao\" = '"+authorizationCode+"'")
                updated = cursor.rowcount

                self.connection.commit()
                if updated > 0:
                    return True
                return False

        except Exception as e:
            print(e)
            return None
        
    def updateAndRegisterToken(self, idUser, idRegLogin, token, validity, idDevice):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("UPDATE \"zt-ehealth\".\"Token\" SET status='Inativo' WHERE \"idUsuario\" = '"+str(idUser)+"' AND status = 'Ativo'")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Token\"(\"idUsuario\", \"idRegLogin\", hash, validade, status, \"idDispositivo\") VALUES ('"+str(idUser)+"', '"+str(idRegLogin)+"', '"+token+"', '"+str(validity)+"', 'Ativo', '"+str(idDevice)+"')")

                self.connection.commit()
                updated = cursor.rowcount
                if updated > 0:
                    return True
                return False

        except Exception as e:
            print(e)
            return None
        
    def getDeviceIdByCode(self, authorizationCode):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT \"idDispositivo\" FROM \"zt-ehealth\".\"RegLogin\" WHERE \"codigoAutorizacao\" = '"+authorizationCode+"' AND completado = 'false'")
                result = cursor.fetchone()
                if result:
                    return result[0]
                return None

        except Exception as e:
            print(e)
            return None