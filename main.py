import docker
import json
import reset
import os
import results.results_plot as plot

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
                instanceName = "instance-C1.json"
            case "2":
                instanceName = "instance-C2T1.json"
            case "3":
                instanceName = "instance-C2T2.json"
            case "4":
                instanceName = "instance-C3.json"
            case "5":
                instanceName = "instance-C4T1.json"
            case "6":
                instanceName = "instance-C4T2.json"
            case "7":
                instanceName = "instance-C5.json"
            case "8":
                instanceName = "instance-C6T1.json"
            case "9":
                instanceName = "instance-C6T2.json"
            case "10":
                instanceName = "instance-C6T3.json"
            case "11":
                instanceName = "instance-C6T4.json"
            case "12":
                exit()
            case _:
                print("Opção Inválida!")
                option = input("Opção: ")
        if instanceName != "":
            break

    with open(f"clients/scenarios/{instanceName}") as f:
        clients = json.load(f)


    for idx, client in enumerate(clients):
        container = dkr.containers.run(
            "zero_trust-client",
            detach=True,
            name=f"{CLIENT_PREFIX}{idx}",
            environment={
                "IP_ZERO_TRUST": "169.254.0.2",
                "PORT_ZERO_TRUST": "5000",
                "OPERATIONS": json.dumps(client["OPERATIONS"])
            },
            network="zero_trust"
        )
        print(f"Container {container.name} criado")

    input("Aguarde a execução de todos os clientes e pressione Enter exibir os resultados...")
    plot.showResults()


def printMenu():
    print("SELECIONE O CENÁRIO:")
    print("1 - Cenário 1 - Acesso Normal")
    print("2 - Cenário 2 - Roubo de Token - Teste 1")
    print("3 - Cenário 2 - Roubo de Token - Teste 2")
    print("4 - Cenário 3 - Roubo de Credenciais")
    print("5 - Cenário 4 - Ataque de Força Bruta - Sem Sucesso")
    print("6 - Cenário 4 - Ataque de Força Bruta - Com Sucesso")
    print("7 - Cenário 5 - Dispositivo Compartilhado")
    print("8 - Cenário 6 - Acesso fora do Horário - Teste 1")
    print("9 - Cenário 6 - Acesso fora do Horário - Teste 2")
    print("10 - Cenário 6 - Acesso fora do Horário - Teste 3")
    print("11 - Cenário 6 - Acesso fora do Horário - Teste 4")
    print("12 - SAIR")

if __name__ == "__main__":
    startClients()