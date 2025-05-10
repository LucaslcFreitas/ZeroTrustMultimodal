import datetime
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.dates import DateFormatter
import psycopg2
import json
import os
import pytz

connection = psycopg2.connect(
    host="localhost",
    port=5433,
    database="zt-ehealth",
    user="postgres",
    password="zerotrust"
)

# userRegistry = "460.395.930-32"
userRegistry = "649.122.660-35"
# userRegistry = "859.310.680-31"
# userRegistry = "465.994.610-00"
# userRegistry = "773.391.700-06"

try:
    with connection.cursor() as cursor:
        cursor.execute("SELECT data, \"scorePPG\", \"scoreECG\" FROM \"zt-ehealth\".\"RegLogin\" WHERE \"idUsuario\" = (SELECT id from \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+userRegistry+"') ORDER BY data ASC")
        resultRg = cursor.fetchall()
        if resultRg:
            accessReg = resultRg
        else:
            exit()
except Exception as e:
    print(e)
    exit()

try:
    with connection.cursor() as cursor:
        cursor.execute("SELECT ac.data, ac.\"confiancaContexto\", ac.\"confiancaDispositivo\", ac.\"confiancaHistorico\", se.sensibilidade FROM \"zt-ehealth\".\"Acesso\" AS ac INNER JOIN (SELECT atP.id AS ipt, atS.* FROM \"zt-ehealth\".\"Permissao\" AS atP INNER JOIN \"zt-ehealth\".\"SensibilidadeSubRecurso\" AS atS ON atP.\"idSubRecurso\" = atS.\"idSubRecurso\" AND atp.\"tipoAcao\" = ats.\"tipoAcao\") AS se ON ac.\"idPermissao\" = se.ipt WHERE ac.\"idUsuario\" = (SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+userRegistry+"') AND resultado <> 'Reautenticacao' ORDER BY data ASC")
        resultAc = cursor.fetchall()
        if resultAc:
            accessTrust = resultAc
        else:
            exit()
except Exception as e:
    print(e)
    exit()

scorePPG = []
scoreECG = []
auxDataScore = []
for reg in accessReg:
    auxDataScore.append(reg[0])
    scorePPG.append(reg[1])
    scoreECG.append(reg[2])


dataScore = []
for data in auxDataScore:
    dataScore.append(data - datetime.timedelta(hours=3))


sensibility = []
contextTrust = []
deviceTrust = []
historyTrust = []
auxAccessData = []
for ac in accessTrust:
    auxAccessData.append(ac[0])
    contextTrust.append(ac[1])
    deviceTrust.append(ac[2])
    historyTrust.append(ac[3])
    sensibility.append(ac[4])


accessData = []
for data in auxAccessData:
    accessData.append(data - datetime.timedelta(hours=3))

if dataScore[len(dataScore) - 1] < accessData[len(accessData) - 1]:
    dataScore.append(accessData[len(accessData) - 1])
    scorePPG.append(scorePPG[len(scorePPG) - 1])
    scoreECG.append(scoreECG[len(scoreECG) - 1])

fig, ax = plt.subplots()
ax.plot(dataScore, scorePPG, color='red', label='Precisão PPG')
ax.plot(dataScore, scoreECG, color='green', label='Precisão ECG')

ax.plot(accessData, contextTrust, color='blue', label='Confiança de Contexto')
ax.plot(accessData, deviceTrust, color='orange', label='Confiança de Dispositivo')
ax.plot(accessData, historyTrust, color='purple', label='Confiança de Histórico')

date_formatter = mdates.DateFormatter('%H:%M:%S')
plt.gca().xaxis.set_major_formatter(date_formatter)
plt.gca().xaxis.set_major_locator(mdates.AutoDateLocator())

plt.gcf().autofmt_xdate()

ax.set(xlabel='tempo', ylabel='pontuação',
       title='Precisão da autenticação biomética PPG e ECG, confiança do contexto, dispositivo e histórico')
ax.grid(True, linestyle='--', linewidth=0.9, color='gray', alpha=0.5)
ax.legend(title='Pontuações')

plt.show()