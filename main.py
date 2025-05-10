import docker
import json
import reset
import os
import results.results_plot as plot
from random_access.instance_random_normal import getRandomNormal
from random_access.instance_random_improper_user import getRandomImproperUser

dkr = docker.from_env()

CLIENT_PREFIX = "client_"


def startClients():
    print("Removendo containers antigos...")
    for container in dkr.containers.list(all=True):
        if container.name.startswith(CLIENT_PREFIX):
            print(f"Removendo {container.name}...")
            container.remove(force=True)
    print("Todos os containers de clientes removidos.\n")


    print("Resetando o banco de dados...")
    try:
        with open(os.path.dirname(os.path.abspath(__file__)) + "/config.json") as file:
            config = json.load(file)
        reset.resetDatabase(config["dbHost"], config["dbPort"], config["dbDatabase"], config["dbUser"], config["dbPassword"])
        print("Banco de dados resetado\n")
    except Exception as e:
        print("Erro ao resetar o banco de dados: " + e)
        exit()

    printMenu()

    option = input("Opção: ")
    instanceName = ""
    while option != 13:
        match option:
            case "1":
                instanceName = "randomNormal"
            case "2":
                instanceName = "randomImproperUser"
            case "13":
                exit()
            case _:
                print("Opção Inválida!")
                option = input("Opção: ")
        if instanceName != "":
            break

    if instanceName == "randomNormal":
        clients = getRandomNormal(200)
    elif instanceName == "randomImproperUser":
        clients = getRandomImproperUser(200)


    for idx, client in enumerate(clients):
        container = dkr.containers.run(
            "zero_trust-client",
            detach=True,
            name=f"{CLIENT_PREFIX}{idx}",
            environment={
                "IP_ZERO_TRUST": "169.254.0.2",
                "PORT_ZERO_TRUST": "5000",
                "OPERATIONS": json.dumps(client["OPERATIONS"]),
                "USERS": json.dumps(client["USERS"])
            },
            network="zero_trust"
        )
        print(f"Container {container.name} criado")

    input("Aguarde a execução de todos os clientes e pressione Enter exibir os resultados...")
    plot.showResults()


def printMenu():
    print("SELECIONE O CENÁRIO:")
    print("1 - Random Normal")
    print("2 - Usuário Indevido")
    print("13 - SAIR")

if __name__ == "__main__":
    startClients()