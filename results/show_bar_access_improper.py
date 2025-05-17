import datetime
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
from matplotlib.dates import DateFormatter
import psycopg2
import json
import os
import pytz
import numpy as np

def showBar():
    with open(os.path.dirname(os.path.abspath(__file__)) + "/config.json") as file:
        config = json.load(file)

    connection = psycopg2.connect(
        host=config["dbHost"],
        port=config["dbPort"],
        database=config["dbDatabase"],
        user=config["dbUser"],
        password=config["dbPassword"]
    )

    usersData = [
        {
            "name": 'Medico',
            "registry": '460.395.930-32',
            "min": '2025-04-09 11:36:19.047062'
        },
        {
            "name": 'Enfermeiro',
            "registry": '649.122.660-35',
            "min": '2025-04-10 10:23:01.047062'
        },
        {
            "name": "Atendente",
            "registry": "859.310.680-31",
            "min": '2025-04-14 16:44:37.047062'
        },
        {
            "name": "Administrador",
            "registry": "465.994.610-00",
            "min": '2025-04-17 14:24:22.047062'
        },
        {
            "name": "Paciente",
            "registry": "773.391.700-06",
            "min": '2025-04-18 14:24:22.047062'
        }
    ]

    alowed = []
    denied = []
    alowedByReauthentication = []
    deniedByReauthentication = []

    users = []

    for user in usersData:
        al, de, alr, der = getAccessScores(connection, user["registry"], user["min"])
        alowed.append(al)
        denied.append(de)
        alowedByReauthentication.append(alr)
        deniedByReauthentication.append(der)
        users.append(user["name"])

    chartData = {
        'Permitido': alowed,
        'Permitido por reautenticacao': alowedByReauthentication,
        'Negado': denied,
        'Negado por reautenticacao': deniedByReauthentication,
    }

    colors = {
        'Permitido': '#005900',
        'Permitido por reautenticacao': '#0000cc', 
        'Negado': '#cc0000', 
        'Negado por reautenticacao': '#e89275',
    }

    x = np.arange(len(users)) 
    width = 0.2
    multiplier = 0

    fig, ax = plt.subplots(layout='constrained', figsize=(12, 6))

    for attribute, measurement in chartData.items():
        offset = width * multiplier
        rects = ax.bar(x + offset, measurement, width, label=attribute, color=colors[attribute])
        ax.bar_label(rects, padding=3)
        multiplier += 1

    ax.set_ylabel('Quantidade')
    ax.set_title('Acessos por usuários indevidos')
    ax.set_xticks(x + width*(len(chartData)-1)/2, users)
    ax.legend(loc='upper left', ncols=2)
    ax.set_ylim(0, 250)

    plt.show()
    print(chartData)


def getAccessScores(connection, registry, min):
    alowed = 0
    denied = 0
    alowedByReauthentication = 0
    deniedByReauthentication = 0
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT resultado, reautenticacao FROM \"zt-ehealth\".\"Acesso\" WHERE \"idUsuario\" = (SELECT id FROM \"zt-ehealth\".\"Usuario\" WHERE cpf = '"+registry+"') AND resultado <> 'Reautenticacao' AND data > '"+min+"'")
            result = cursor.fetchall()
            if result:
                for access in result:
                    if access[0] == 'Permitido' and access[1] == False:
                        alowed += 1
                    elif access[0] == 'Permitido' and access[1] == True:
                        alowedByReauthentication += 1
                    elif access[1] == False:
                        denied += 1
                    else:
                        deniedByReauthentication += 1
            else:
                exit()
        return alowed, denied, alowedByReauthentication, deniedByReauthentication
    except Exception as e:
        print(e)
        exit()

if __name__ == '__main__':
    showBar()