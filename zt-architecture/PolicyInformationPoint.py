import psycopg2
import os
import json
import datetime

class PolicyInformationPoint:
    config = {
        "dbHost": None,
        "dbPort": None,
        "dbDatabase": None,
        "dbUser": None,
        "dbPassword": None
    }

    def __init__(self) -> None:
        try:
            self.config['dbHost'] = os.getenv("DBHOST", "localhost")
            self.config['dbPort'] = int(os.getenv("DBPORT", 5432))
            self.config['dbDatabase'] = os.getenv("DBDATABASE", "zt-ehealth")
            self.config['dbUser'] = os.getenv("DBUSER", "postgres")
            self.config['dbPassword'] = os.getenv("DBPASSWORD", "")
            
            self.connection = None
            self.connect()
        except:
            exit()
            

    def connect(self) -> None:
        print(self.config)
        try:
            self.connection = psycopg2.connect(
                host=self.config["dbHost"],
                port=self.config["dbPort"],
                database=self.config["dbDatabase"],
                user=self.config["dbUser"],
                password=self.config["dbPassword"]
            )
        except Exception as e:
            print(e)
            exit()

    def closeConnection(self) -> None:
        if self.connection:
            self.connection.close()

    def registerUser(self, name, type, registry, registryCode, date):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Usuario\" (\"nome\", \"tipo\", \"cpf\", \"codigoCriacao\", \"dataCriacao\") VALUES ('"+name+"', '"+type+"', '"+registry+"', '"+registryCode+"', '"+date+"') RETURNING id")
                userId = cursor.fetchone()[0]

                if userId:
                    self.connection.commit()
                    return userId
                return None
        except Exception as e:
            print(e)
            return None
        
    def registerProfessional(self, position, daysWork, idUser, startWorkingHours, endWorkingHours):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Profissional\" (\"cargo\", \"diasTrabalho\", \"idUsuario\", \"horarioTrabalhoInicio\", \"horarioTrabalhoFinal\") VALUES ('"+position+"', '"+daysWork+"', '"+str(idUser)+"', '"+startWorkingHours+"', '"+endWorkingHours+"') RETURNING id")
                professionalId = cursor.fetchone()[0]

                if professionalId:
                    self.connection.commit()
                    return professionalId
                return None

        except Exception as e:
            print(e)
            return None
        
    def registerPatient(self, userId):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Paciente\" (\"idUsuario\") VALUES ('"+str(userId)+"') RETURNING id")
                patientId = cursor.fetchone()[0]

                if patientId:
                    self.connection.commit()
                    return patientId
                return None
        except Exception as e:
            print(e)
            return None
        
    def registerPermission(self, userId, subResourceName, resourceName, action, date, status):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT id FROM \"zt-ehealth\".\"SubRecurso\" WHERE nome = '"+subResourceName+"' AND \"idRecurso\" = (SELECT id FROM \"zt-ehealth\".\"Recurso\" WHERE nome = '"+resourceName+"')")
                idSubResource = cursor.fetchone()
                if idSubResource:
                    cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '"+str(idSubResource[0])+"', '"+str(action)+"', '"+str(date)+"', '"+str(status)+"') RETURNING id")
                    permissionId = cursor.fetchone()[0]
                    if permissionId:
                        self.connection.commit()
                        return permissionId
                return None
        except Exception as e:
            print(e)
            return None
        
    def registerPermissionForDoctors(self, userId, date):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '1', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '2', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '2', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '2', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '2', 'Exclusao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '3', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '3', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '3', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '3', 'Exclusao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '4', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '4', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '4', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '4', 'Exclusao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '5', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '5', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '5', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '5', 'Exclusao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '6', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '6', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '6', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '7', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '8', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '8', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '8', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '8', 'Exclusao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '9', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '10', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '11', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '11', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '11', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '11', 'Exclusao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '14', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '15', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '16', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '18', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '19', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '20', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '20', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '20', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '20', 'Exclusao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '23', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '24', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '25', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '25', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '25', 'Exclusao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '26', 'Acesso', '"+str(date)+"', 'Ativo') RETURNING id")
                rows_affected = cursor.rowcount
                if rows_affected > 0:
                    self.connection.commit()
                    return True
                return False
        except Exception as e:
            print(e)
            return False
        
    def registerPermissionForNurse(self, userId, date):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '1', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '2', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '3', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '3', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '3', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '3', 'Exclusao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '5', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '7', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '8', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '9', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '10', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '11', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '14', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '15', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '16', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '19', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '20', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '23', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '24', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                rows_affected = cursor.rowcount
                if rows_affected > 0:
                    self.connection.commit()
                    return True
                return False
        except Exception as e:
            print(e)
            return False
        
    def registerPermissionForAttendant(self, userId, date):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '1', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '1', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '1', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '7', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '9', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '9', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '9', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '11', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '12', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '12', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '12', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '21', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '22', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '22', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '22', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '22', 'Exclusao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '23', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                rows_affected = cursor.rowcount
                if rows_affected > 0:
                    self.connection.commit()
                    return True
                return False
        except Exception as e:
            print(e)
            return False
        
    def registerPermissionForAdministrator(self, userId, date):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '10', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '10', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '10', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '10', 'Exclusao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '12', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '12', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '12', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '12', 'Exclusao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '13', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '13', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '13', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '13', 'Exclusao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '14', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '14', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '14', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '14', 'Exclusao', '"+str(date)+"', 'Ativo') RETURNING id")
                rows_affected = cursor.rowcount
                if rows_affected > 0:
                    self.connection.commit()
                    return True
                return False
        except Exception as e:
            print(e)
            return False
        
    def registerPermissionForPatient(self, userId, date):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '15', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '16', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '18', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '19', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '19', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '20', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '21', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '22', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '22', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '23', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '23', 'Escrita', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '24', 'Leitura', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '24', 'Modificacao', '"+str(date)+"', 'Ativo') RETURNING id")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Permissao\" (\"idUsuario\", \"idSubRecurso\", \"tipoAcao\", \"dataCriacao\", \"status\") VALUES ('"+str(userId)+"', '26', 'Acesso', '"+str(date)+"', 'Ativo') RETURNING id")
                rows_affected = cursor.rowcount
                if rows_affected > 0:
                    self.connection.commit()
                    return True
                return False
        except Exception as e:
            print(e)
            return False

    def getUserAttributes(self, token) -> json:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT nome, tipo, cpf FROM \"zt-ehealth\".\"Usuario\" WHERE id = (SELECT \"idUsuario\" FROM \"zt-ehealth\".\"Token\" WHERE hash = '"+token+"')")
                result = cursor.fetchone()
                if result:
                    return {
                        "name": result[0],
                        "type": result[1],
                        "registry": result[2]
                    }
                return None
        except Exception as e:
            print(e)
            return None
        
    def getEmployeeAttributes(self, cpf) -> json:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT * FROM \"zt-ehealth\".\"Profissional\" WHERE \"idUsuario\" = (SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"')")
                result = cursor.fetchone()
                if result:
                    return {
                        "type": result[1],
                        "workDays": result[2],
                        "wrokStart": result[4],
                        "workEnd": result[5]
                    }
                return None
        except Exception as e:
            print(e)
            return None

    def checkTokenValidity(self, token, currentDate) -> bool:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT validade FROM \"zt-ehealth\".\"Token\" WHERE hash = '" + token + "' AND status = 'Ativo'")
                validity = cursor.fetchone()
                if validity:
                    if (datetime.datetime.strptime(currentDate, "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=datetime.timezone(datetime.timedelta(hours=-3))) <= validity[0]):
                        return True
                    else:
                        cursor.execute("UPDATE \"zt-ehealth\".\"Token\" SET status='Inativo' WHERE hash = '"+token+"'")
                        self.connection.commit()
                return False
        except Exception as e:
            print(e)
            return False
        
    def checkPasswordValidity(self, cpf, pswToken):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT * FROM \"zt-ehealth\".\"Senha\" WHERE senha = '"+pswToken+"' AND status = 'Ativo' and \"idUsuario\" = (SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"')")
                result = cursor.fetchone()
                if result:
                    return True
                return False
        except Exception as e:
            print(e)
            return False
        
    def getResourceSensibilityByName(self, resourceName, subResourceName, typeAction) -> float:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT sensibilidade FROM \"zt-ehealth\".\"SensibilidadeSubRecurso\" WHERE \"tipoAcao\" = '"+typeAction+"' AND \"idSubRecurso\" = (SELECT id FROM \"zt-ehealth\".\"SubRecurso\" WHERE nome = '"+subResourceName+"' AND \"idRecurso\" = (SELECT id FROM \"zt-ehealth\".\"Recurso\" WHERE nome = '"+resourceName+"'))")
                result = cursor.fetchone()
                if result:
                    return result[0]
                return None
        except Exception as e:
            print(e)
            return None
    
    def getResourceSocketByName(self, resourceName) -> json:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT \"ipAddress\", porta FROM \"zt-ehealth\".\"Recurso\" WHERE nome = '"+resourceName+"'")
                result = cursor.fetchone()
                if result:
                    return {
                        'ipAddress': result[0],
                        'port': result[1]
                    }
                return None
        except Exception as e:
            print(e)
            return None
    
    def getSubResourceSocketByName(self, resourceName, subResourceName) -> json:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT r.\"ipAddress\", r.porta FROM \"zt-ehealth\".\"Recurso\" AS r INNER JOIN \"zt-ehealth\".\"SubRecurso\" AS s ON r.id = s.\"idRecurso\" WHERE r.nome = '"+resourceName+"' AND s.nome = '"+subResourceName+"'")
                result = cursor.fetchone()
                if result:
                    return {
                        'ipAddress': result[0],
                        'port': result[1]
                    }
                return None
        except Exception as e:
            print(e)
            return None
    
    def getResourceSocketBySubResourceId(self, subResourceId) -> json:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT \"ipAddress\", porta FROM \"zt-ehealth\".\"Recurso\" WHERE id = (SELECT \"idRecurso\" FROM \"zt-ehealth\".\"SubRecurso\" WHERE id = "+str(subResourceId)+")")
                result = cursor.fetchone()
                if result:
                    return {
                        'ipAddress': result[0],
                        'port': result[1]
                    }
                return None
        except Exception as e:
            print(e)
            return None
        
    def checkResourceUserPermissions(self, tokenUser, resourceName, subResourceName, typeAction, currentDate) -> bool:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT * FROM \"zt-ehealth\".\"Permissao\" WHERE \"idUsuario\" = (SELECT \"idUsuario\" FROM \"zt-ehealth\".\"Token\" WHERE hash = '"+tokenUser+"' AND status = 'Ativo' AND validade >= '"+str(currentDate)+"' ) AND \"idSubRecurso\" = (SELECT id FROM \"zt-ehealth\".\"SubRecurso\" WHERE nome = '"+subResourceName+"' AND \"idRecurso\" = (SELECT id FROM \"zt-ehealth\".\"Recurso\" WHERE nome = '"+resourceName+"')) AND \"tipoAcao\" = '"+typeAction+"'")
                result = cursor.fetchone()
                if result:
                    return True
                return False
        except Exception as e:
            print(e)
            return False
        
    def checkLogin(self, cpf) -> bool:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"'")
                result = cursor.fetchone()
                if result:
                    return True
                return False
        except Exception as e:
            print(e)
            return False
    
    def registerLoginAndToken(self, cpf, date, idDevice, authorizationCode) -> bool:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("INSERT INTO \"zt-ehealth\".\"RegLogin\"(\"idUsuario\", data, \"idDispositivo\", completado, \"codigoAutorizacao\") VALUES ((SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"'), '"+date+"', '"+str(idDevice)+"', 'false', '"+authorizationCode+"') RETURNING id")
                regLoginId = cursor.fetchone()[0]

                self.connection.commit()
                
                if regLoginId :
                    return True
                return False
        except Exception as e:
            print(e)
            return False
        
    def updatePassword(self, cpf, token, date) -> bool:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("UPDATE \"zt-ehealth\".\"Senha\" SET status='Inativo' WHERE status='Ativo' AND \"idUsuario\"=(SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"')")
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Senha\"(\"idUsuario\", senha, \"dataCriacao\", status) VALUES ((SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"'), '"+token+"', '"+date+"', 'Ativo')")
                rows_affected = cursor.rowcount
                if rows_affected > 0:
                    self.connection.commit()
                    return True
                return False
        except Exception as e:
            print(e)
            return False
    
    def getUserWorkPeriod(self, cpf) -> json:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"' AND tipo = 'Profissional'")
                idUser = cursor.fetchone()[0]
                if idUser:
                    cursor.execute("SELECT * FROM \"zt-ehealth\".\"Profissional\" WHERE \"idUsuario\" = '"+str(idUser)+"'")
                    result = cursor.fetchone()
                    return {
                        "startWorkTime": result[4],
                        "endWorkTime": result[5],
                        "daysWork": result[2]
                    }
                return None
        except Exception as e:
            print(e)
            return None
        
    def getUserPasswordHistory(self, cpf, currentDate) -> list:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                date = datetime.datetime.strptime(currentDate, "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=datetime.timezone(datetime.timedelta(hours=-3))) - datetime.timedelta(hours=72) # 3 dias
                cursor.execute("SELECT \"dataCriacao\", status FROM \"zt-ehealth\".\"Senha\" WHERE \"idUsuario\" = (SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"') AND \"dataCriacao\" >= '"+str(date)+"'")
                result = cursor.fetchall()
                if result:
                    return result
                return None
        except Exception as e:
            print(e)
            return None
        
    def getRegLoginDeniedHistory(self, cpf, currentDate) -> list:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                date = datetime.datetime.strptime(currentDate, "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=datetime.timezone(datetime.timedelta(hours=-3))) - datetime.timedelta(hours=72) # 3 dias
                cursor.execute("SELECT data, resultado FROM \"zt-ehealth\".\"RegLogin\" WHERE \"idUsuario\" = (SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"') AND data >= '"+str(date)+"' ORDER BY data DESC LIMIT 20")
                result = cursor.fetchall()
                if result:
                    return result
                return None
        except Exception as e:
            print(e)
            return None
        
    def getRecentLocationAccessUser(self, cpf, currentDate) -> list:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                date = datetime.datetime.strptime(currentDate, "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=datetime.timezone(datetime.timedelta(hours=-3))) - datetime.timedelta(hours=7) #7 horas
                cursor.execute("SELECT latitude, longitude, data, resultado FROM \"zt-ehealth\".\"Acesso\" WHERE resultado = 'Permitido' AND \"idUsuario\" = (SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"') AND data >= '"+str(date)+"' ORDER BY data DESC LIMIT 15")
                result = cursor.fetchall()
                if result:
                    return result
                return None
        except Exception as e:
            print(e)
            return None
        
    def getHistoryLocationAccessUser(self, cpf, currentDate) -> list:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                date = datetime.datetime.strptime(currentDate, "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=datetime.timezone(datetime.timedelta(hours=-3))) - datetime.timedelta(hours=720) #30 dias
                cursor.execute("SELECT latitude, longitude, data, resultado FROM \"zt-ehealth\".\"Acesso\" WHERE resultado = 'Permitido' AND \"idUsuario\" = (SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"') AND data >= '"+str(date)+"'")
                result = cursor.fetchall()
                if result:
                    return result
                return None
        except Exception as e:
            print(e)
            return None
    
    def getRecentReducedPrivilege(self, cpf, currentDate):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                date = datetime.datetime.strptime(currentDate, "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=datetime.timezone(datetime.timedelta(hours=-3))) - datetime.timedelta(hours=336) #2 semanas
                cursor.execute("SELECT status, \"dataExclusao\" FROM \"zt-ehealth\".\"Permissao\" WHERE \"idUsuario\" = (SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"') AND status = 'Inativo' AND \"dataExclusao\" >= '"+str(date)+"'")
                result = cursor.fetchall()
                if result:
                    return result
                return None
        except Exception as e:
            print(e)
            return None

    def getRecentNetworkUse(self, cpf, currentDate):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                date = datetime.datetime.strptime(currentDate, "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=datetime.timezone(datetime.timedelta(hours=-3))) - datetime.timedelta(hours=7) #7 horas
                cursor.execute("SELECT rede, data FROM \"zt-ehealth\".\"Acesso\" WHERE resultado = 'Permitido' AND \"idUsuario\" = (SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"') AND data >= '"+str(date)+"'")
                result = cursor.fetchall()
                if result:
                    return result
                return None
        except Exception as e:
            print(e)
            return None
    
    def getAcessHistoricByUser(self, cpf, currentDate):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                date = datetime.datetime.strptime(currentDate, "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=datetime.timezone(datetime.timedelta(hours=-3))) - datetime.timedelta(hours=336) #2 semanas
                cursor.execute("SELECT \"idUsuario\", \"idToken\", \"idPermissao\", \"idSubRecurso\", \"idSensibilidadeSubRecurso\", \"idDispositivo\", latitude, longitude, data, resultado, rede, confianca FROM \"zt-ehealth\".\"Acesso\" WHERE \"idUsuario\" = (SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"') AND data >= '"+str(date)+"'")
                result = cursor.fetchall()
                if result:
                    return result
                return None
        except Exception as e:
            print(e)
            return None

    def getAcessHistoricByDevice(self, MAC, currentDate):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                date = datetime.datetime.strptime(currentDate, "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=datetime.timezone(datetime.timedelta(hours=-3))) - datetime.timedelta(hours=168) # 7 dias
                cursor.execute("SELECT \"idUsuario\", \"idToken\", \"idPermissao\", \"idSubRecurso\", \"idSensibilidadeSubRecurso\", \"idDispositivo\", latitude, longitude, data, resultado, rede, confianca FROM \"zt-ehealth\".\"Acesso\" WHERE \"idDispositivo\" = (SELECT id FROM \"zt-ehealth\".\"Dispositivo\" WHERE \"MAC\" = '"+MAC+"') AND data >= '"+str(date)+"'")
                result = cursor.fetchall()
                if result:
                    return result
                return None
        except Exception as e:
            print(e)
            return None
        
    def getAccessHistoryWithSensibility(self, cpf, currentDate):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                date = datetime.datetime.strptime(currentDate, "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=datetime.timezone(datetime.timedelta(hours=-3))) - datetime.timedelta(hours=168) #2 semanas
                cursor.execute("SELECT ac.*, se.sensibilidade FROM \"zt-ehealth\".\"Acesso\" AS ac INNER JOIN (SELECT atP.id AS ipt, atS.* FROM \"zt-ehealth\".\"Permissao\" AS atP INNER JOIN \"zt-ehealth\".\"SensibilidadeSubRecurso\" AS atS ON atP.\"idSubRecurso\" = atS.\"idSubRecurso\" AND atp.\"tipoAcao\" = ats.\"tipoAcao\") AS se ON ac.\"idPermissao\" = se.ipt WHERE ac.\"idUsuario\" = (SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"') AND ac.data >= '"+str(date)+"' AND ac.resultado <> 'Reautenticacao' ORDER BY ac.data DESC LIMIT 20")
                result = cursor.fetchall()
                if result:
                    return result
                return None
        except Exception as e:
            print(e)
            return None
        
    def getNumberAccessByUser(self, cpf):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT COUNT(\"idUsuario\") FROM \"zt-ehealth\".\"Acesso\" WHERE \"idUsuario\" = (SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"') AND resultado <> 'Reautenticacao'")
                result = cursor.fetchone()
                if result:
                    return result[0]
                return 0
        except Exception as e:
            print(e)
            return 0
        
    def getNumberAccessByDevice(self, MAC):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT COUNT(\"idUsuario\") FROM \"zt-ehealth\".\"Acesso\" WHERE \"idDispositivo\" = (SELECT id FROM \"zt-ehealth\".\"Dispositivo\" WHERE \"MAC\" = '"+MAC+"') AND resultado = 'Permitido'")
                result = cursor.fetchone()
                if result:
                    return result[0]
                return 0
        except Exception as e:
            print(e)
            return 0

    def getDeviceByMAC(self, MAC):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT * FROM \"zt-ehealth\".\"CaracteristicaDispositivo\" AS c INNER JOIN \"zt-ehealth\".\"Dispositivo\" AS d ON c.\"idDispositivo\"= d.id WHERE d.\"MAC\" = '"+MAC+"' AND c.status = 'Ativo'")
                result = cursor.fetchone()
                if result:
                    return result
                return None
        except Exception as e:
            print(e)
            return None
        
    def getDeviceIdByMAC(self, MAC):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT id FROM \"zt-ehealth\".\"Dispositivo\"")
                result = cursor.fetchone()
                if result:
                    return result[0]
                return None
        except Exception as e:
            print(e)
            return None
        
    def getDeviceById(self, id):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT * FROM \"zt-ehealth\".\"CaracteristicaDispositivo\" AS c INNER JOIN \"zt-ehealth\".\"Dispositivo\" AS d ON c.\"idDispositivo\"= d.id WHERE d.id = '"+str(id)+"' AND c.status = 'Ativo'")
                result = cursor.fetchone()
                if result:
                    return result
                return None
        except Exception as e:
            print(e)
            return None
        
    def getDeviceTMPById(self, id):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT * FROM \"zt-ehealth\".\"DispositivoTMP\" WHERE id = "+str(id)+"")
                result = cursor.fetchone()
                if result:
                    return result
                return None
        except Exception as e:
            print(e)
            return None

    def checkRecentDeviceChanges(self, MAC, currentDate):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                date = datetime.datetime.strptime(currentDate, "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=datetime.timezone(datetime.timedelta(hours=-3))) - datetime.timedelta(hours=72) #3 dias
                cursor.execute("SELECT \"deviceFingerPrint\", \"sistemaOperacional\", \"versaoSO\", data, status FROM \"zt-ehealth\".\"CaracteristicaDispositivo\" WHERE \"idDispositivo\" = (SELECT id FROM \"zt-ehealth\".\"Dispositivo\" WHERE \"MAC\" = '"+MAC+"') AND data >= '"+str(date)+"'")
                result = cursor.fetchall()
                if result:
                    return result
                return None
        except Exception as e:
            print(e)
            return None

    def registerDevice(self, MAC, deviceFingerPrint, SO, versionSO, date) -> bool:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Dispositivo\"(\"MAC\") VALUES ('"+MAC+"') RETURNING id")
                deviceId = cursor.fetchone()[0]

                if deviceId:
                    cursor.execute("INSERT INTO \"zt-ehealth\".\"CaracteristicaDispositivo\"(\"deviceFingerPrint\", \"sistemaOperacional\", \"versaoSO\", data, status, \"idDispositivo\") VALUES ('"+deviceFingerPrint+"', '"+SO+"', '"+versionSO+"', '"+date+"', 'Ativo', "+str(deviceId)+")")
                    self.connection.commit()
                    return True
                return False
        except Exception as e:
            print(e)
            return False
        
    def registerDeviceTMP(self, MAC, deviceFingerPrint, OS, versionOS, date) -> bool:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("INSERT INTO \"zt-ehealth\".\"DispositivoTMP\" (\"MAC\", \"deviceFingerPrint\", \"SistemaOperacional\", \"versaoSO\", data) VALUES ('"+MAC+"', '"+deviceFingerPrint+"', '"+OS+"', '"+versionOS+"', '"+date+"') RETURNING id")
                deviceId = cursor.fetchone()[0]

                if deviceId:
                    self.connection.commit()
                    return deviceId
                return None
        except Exception as e:
            print(e)
            return None
        
    def updateDeviceCharacteristic(self, MAC, deviceFingerPrint, SO, versionSO, date) -> bool:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("UPDATE \"zt-ehealth\".\"CaracteristicaDispositivo\" SET status='Inativo' WHERE \"idDispositivo\" = (SELECT id FROM \"zt-ehealth\".\"Dispositivo\" WHERE \"MAC\" = '"+MAC+"') AND status = 'Ativo'")
                updated = cursor.rowcount

                if updated > 0:
                    cursor.execute("INSERT INTO \"zt-ehealth\".\"CaracteristicaDispositivo\"(\"deviceFingerPrint\", \"sistemaOperacional\", \"versaoSO\", data, status, \"idDispositivo\") VALUES ('"+deviceFingerPrint+"', '"+SO+"', '"+versionSO+"', '"+date+"', 'Ativo', (SELECT id FROM \"zt-ehealth\".\"Dispositivo\" WHERE \"MAC\" = '"+MAC+"'))")
                    self.connection.commit()
                    return True
                return False
        except Exception as e:
            print(e)
            return False
    
    def getAverageTrustLastAccess(self, cpf) -> float:
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT AVG(confianca) FROM (SELECT confianca FROM \"zt-ehealth\".\"Acesso\" WHERE \"idUsuario\" = (SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"') AND resultado <> 'Reautenticacao' ORDER BY data DESC LIMIT 3) AS ac")
                result = cursor.fetchone()
                if result:
                    return result[0]
                return 0
        except Exception as e:
            print(e)
            return 0

    def registerAccess(self, cpf, token, latitude, longitude, MAC, date, ipAddress, result, trust, resourceName, subResourceName, typeAction):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Acesso\"(\"idUsuario\", \"idToken\", \"idPermissao\", \"idSubRecurso\", \"idSensibilidadeSubRecurso\", \"idDispositivo\", latitude, longitude, data, resultado, rede, confianca) VALUES ((SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"'), (SELECT id FROM \"zt-ehealth\".\"Token\" WHERE hash = '"+token+"' AND status = 'Ativo'), (SELECT id FROM \"zt-ehealth\".\"Permissao\" WHERE \"idUsuario\" = (SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"') AND \"idSubRecurso\" = ((SELECT id FROM \"zt-ehealth\".\"SubRecurso\" WHERE nome = '"+subResourceName+"' AND \"idRecurso\" = (SELECT id FROM \"zt-ehealth\".\"Recurso\" WHERE nome = '"+resourceName+"'))) AND \"tipoAcao\" = '"+typeAction+"' AND status = 'Ativo'), (SELECT id FROM \"zt-ehealth\".\"SubRecurso\" WHERE nome = '"+subResourceName+"' AND \"idRecurso\" = (SELECT id FROM \"zt-ehealth\".\"Recurso\" WHERE nome = '"+resourceName+"')), (SELECT id FROM \"zt-ehealth\".\"SensibilidadeSubRecurso\" WHERE \"idSubRecurso\" = (SELECT id FROM \"zt-ehealth\".\"SubRecurso\" WHERE nome = '"+subResourceName+"' AND \"idRecurso\" = (SELECT id FROM \"zt-ehealth\".\"Recurso\" WHERE nome = '"+resourceName+"')) AND \"tipoAcao\" = '"+typeAction+"'), (SELECT id FROM \"zt-ehealth\".\"Dispositivo\" WHERE \"MAC\" = '"+MAC+"'), '"+latitude+"', '"+longitude+"', '"+date+"', '"+result+"', '"+ipAddress+"', "+str(trust)+") RETURNING id")
                accessId = cursor.fetchone()[0]
                self.connection.commit()
                if accessId:
                    return accessId
                return None
        except Exception as e:
            print(e)
            return None
    
    def registerAccessDeniedOrReauthenticated(self, cpf, token, latitude, longitude, date, ipAddress, result, trust, resourceName, subResourceName, typeAction, idDeviceTMP):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Acesso\"(\"idUsuario\", \"idToken\", \"idPermissao\", \"idSubRecurso\", \"idSensibilidadeSubRecurso\", latitude, longitude, data, resultado, rede, confianca, \"idDispositivoTMP\") VALUES ((SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"'), (SELECT id FROM \"zt-ehealth\".\"Token\" WHERE hash = '"+token+"' AND status = 'Ativo'), (SELECT id FROM \"zt-ehealth\".\"Permissao\" WHERE \"idUsuario\" = (SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+cpf+"') AND \"idSubRecurso\" = ((SELECT id FROM \"zt-ehealth\".\"SubRecurso\" WHERE nome = '"+subResourceName+"' AND \"idRecurso\" = (SELECT id FROM \"zt-ehealth\".\"Recurso\" WHERE nome = '"+resourceName+"'))) AND \"tipoAcao\" = '"+typeAction+"' AND status = 'Ativo'), (SELECT id FROM \"zt-ehealth\".\"SubRecurso\" WHERE nome = '"+subResourceName+"' AND \"idRecurso\" = (SELECT id FROM \"zt-ehealth\".\"Recurso\" WHERE nome = '"+resourceName+"')), (SELECT id FROM \"zt-ehealth\".\"SensibilidadeSubRecurso\" WHERE \"idSubRecurso\" = (SELECT id FROM \"zt-ehealth\".\"SubRecurso\" WHERE nome = '"+subResourceName+"' AND \"idRecurso\" = (SELECT id FROM \"zt-ehealth\".\"Recurso\" WHERE nome = '"+resourceName+"')) AND \"tipoAcao\" = '"+typeAction+"'), '"+latitude+"', '"+longitude+"', '"+date+"', '"+result+"', '"+ipAddress+"', "+str(trust)+", "+str(idDeviceTMP)+") RETURNING id")
                accessId = cursor.fetchone()[0]
                self.connection.commit()
                if accessId:
                    return accessId
                return None
        except Exception as e:
            print(e)
            return None
    
    def registerAccessAllowedForReauthenticate(self, idUser, token, idPermission, idSubResource, idSensibility, MAC, latitude, longitude, date, result, ip, trust):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Acesso\"(\"idUsuario\", \"idToken\", \"idPermissao\", \"idSubRecurso\", \"idSensibilidadeSubRecurso\", \"idDispositivo\", latitude, longitude, data, resultado, rede, confianca, reautenticacao) VALUES ("+str(idUser)+", (SELECT id FROM \"zt-ehealth\".\"Token\" WHERE hash = '"+token+"' AND status = 'Ativo'), "+str(idPermission)+", "+str(idSubResource)+", "+str(idSensibility)+", (SELECT id FROM \"zt-ehealth\".\"Dispositivo\" WHERE \"MAC\" = '"+MAC+"'), '"+latitude+"', '"+longitude+"', '"+date+"', '"+result+"', '"+ip+"', "+str(trust)+", true) RETURNING id")
                accessId = cursor.fetchone()[0]
                self.connection.commit()
                if accessId:
                    return accessId
                return None
        except Exception as e:
            print(e)
            return None
        
    def registerAccessDeniedForReauthenticate(self, idUser, idToken, idPermission, idSubResource, idSensibility, latitude, longitude, date, result, ip, trust, idDeviceTMP):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("INSERT INTO \"zt-ehealth\".\"Acesso\"(\"idUsuario\", \"idToken\", \"idPermissao\", \"idSubRecurso\", \"idSensibilidadeSubRecurso\", latitude, longitude, data, resultado, rede, confianca, \"idDispositivoTMP\", reautenticacao) VALUES ("+str(idUser)+", "+str(idToken)+", "+str(idPermission)+", "+str(idSubResource)+", "+str(idSensibility)+", '"+latitude+"', '"+longitude+"', '"+date.strftime("%Y-%m-%d %H:%M:%S.%f%z")+"', '"+result+"', '"+ip+"', "+str(trust)+", "+str(idDeviceTMP)+", true) RETURNING id")
                accessId = cursor.fetchone()
                self.connection.commit()
                if accessId:
                    return accessId[0]
                return None
        except Exception as e:
            print(e)
            return None
        
    def getAccessById(self, id):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT * FROM \"zt-ehealth\".\"Acesso\" WHERE id = "+str(id)+"")
                result = cursor.fetchone()
                self.connection.commit()
                if result:
                    return result
                return None
        except Exception as e:
            print(e)
            return None
        
    def getAllHistory(self):
        if not self.connection:
            self.connect()

        try:
            with self.connection.cursor() as cursor:
                cursor.execute("SELECT * FROM \"zt-ehealth\".\"Acesso\"")
                result = cursor.fetchall()
                if result:
                    return result
                return None
        except Exception as e:
            print(e)
            return None