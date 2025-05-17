import datetime
import random
import json
import os
import numpy as np

# TODO: Variar localização, rede
def getRandomImproperUserT2(min):
    baseTimeOp = datetime.datetime.strptime("2025-04-09 10:34:19.047062", "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=datetime.timezone(datetime.timedelta(hours=-3)))
    baseTimeNu = datetime.datetime.strptime("2025-04-10 09:21:01.047062", "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=datetime.timezone(datetime.timedelta(hours=-3)))
    baseTimeAt = datetime.datetime.strptime("2025-04-14 15:42:37.047062", "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=datetime.timezone(datetime.timedelta(hours=-3)))
    baseTimeAd = datetime.datetime.strptime("2025-04-17 13:22:22.047062", "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=datetime.timezone(datetime.timedelta(hours=-3)))
    baseTimePa = datetime.datetime.strptime("2025-04-18 13:22:22.047062", "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=datetime.timezone(datetime.timedelta(hours=-3)))

    
    oprationsDoctor = createInstance(0, 0, min, baseTimeOp, '/resourcesDoctor.json')
    oprationsNurse = createInstance(1, 1, min, baseTimeNu, '/resourcesNurse.json')
    oprationsAttendant = createInstance(2, 2, min, baseTimeAt, '/resourcesAttendant.json')
    oprationsAdministrator = createInstance(3, 3, min, baseTimeAd, '/resourcesAdministrator.json')
    oprationsPatient = createInstance(4, 4, min, baseTimePa, '/resourcesPatient.json')

    instance = [
        {
            "DEVICE": "01",
            "USERS": userData,
            "OPERATIONS": oprationsDoctor
        },
        {
            "DEVICE": "02",
            "USERS": userData,
            "OPERATIONS": oprationsNurse
        },
        {
            "DEVICE": "03",
            "USERS": userData,
            "OPERATIONS": oprationsAttendant
        },
        {
            "DEVICE": "04",
            "USERS": userData,
            "OPERATIONS": oprationsAdministrator
        },
        {
            "DEVICE": "05",
            "USERS": userData,
            "OPERATIONS": oprationsPatient
        },
    ]
    return instance


def createInstance(userInd, deviceInd, min, baseTime, resourcesPath):
    network = '172.16.10.1/24'
    operations = []

    with open(os.path.dirname(os.path.abspath(__file__)) + resourcesPath) as f:
        resources = json.load(f)

    # Realiza o registro
    operations.append(getRegistry(userData[userInd], deviceData[deviceInd], baseTime, network))
    baseTime = baseTime + datetime.timedelta(minutes=1)

    # Realiza o login
    operations.append(getLogin(userData[userInd], deviceData[deviceInd], baseTime, network))
    baseTime = baseTime + datetime.timedelta(minutes=1)


    # Realiza acesso de muito baixa sensibilidade
    if len(resources['veryLowSensivity']) > 0:
        for i in range(15):
            ind = random.randint(0, len(resources['veryLowSensivity'])-1)
            operations.append(getAccess(userData[userInd], deviceData[deviceInd], baseTime, resources['veryLowSensivity'][ind], network))
            baseTime = baseTime + datetime.timedelta(minutes=1)

    # Realiza acesso de baixa sensibilidade
    if len(resources['lowSensivity']) > 0:
        for i in range(15):
            ind = random.randint(0, len(resources['lowSensivity'])-1)
            operations.append(getAccess(userData[userInd], deviceData[deviceInd], baseTime, resources['lowSensivity'][ind], network))
            baseTime = baseTime + datetime.timedelta(minutes=1)

    # Realiza acesso de média sensibilidade
    if len(resources['mediumSensivity']) > 0:
        for i in range(15):
            ind = random.randint(0, len(resources['mediumSensivity'])-1)
            operations.append(getAccess(userData[userInd], deviceData[deviceInd], baseTime, resources['mediumSensivity'][ind], network))
            baseTime = baseTime + datetime.timedelta(minutes=1)

    # Realiza acesso de alta sensibilidade
    if len(resources['highSensivity']) > 0:
        for i in range(5):
            ind = random.randint(0, len(resources['highSensivity'])-1)
            operations.append(getAccess(userData[userInd], deviceData[deviceInd], baseTime, resources['highSensivity'][ind], network))
            baseTime = baseTime + datetime.timedelta(minutes=1)
    else:
        for i in range(5):
            ind = random.randint(0, len(resources['mediumSensivity'])-1)
            operations.append(getAccess(userData[userInd], deviceData[deviceInd], baseTime, resources['mediumSensivity'][ind], network))
            baseTime = baseTime + datetime.timedelta(minutes=1)

    resources = resources['veryLowSensivity'] + resources['lowSensivity'] + resources['mediumSensivity'] + resources['highSensivity']
    random.shuffle(resources)

    # Realiza 10 acessos normais, de forma aleatória
    for i in range(10):
        ind = random.randint(0, len(resources)-1)
        operations.append(getAccess(userData[userInd], deviceData[deviceInd], baseTime, resources[ind], network))
        baseTime = baseTime + datetime.timedelta(minutes=1)

    # Troca os sinais do usuário, dispositivo e rede, simulando intrusão
    operations.append(getChangeSignals(userData[userInd]['REGISTRY']))
    deviceInd = changeDevice()
    network = '169.254.0.0/16'

    if min > 60:
        for i in range(min - 60):
            ind = random.randint(0, len(resources)-1)
            operations.append(getAccess(userData[userInd], alternativeDevice[deviceInd], baseTime, resources[ind], network))
            baseTime = baseTime + datetime.timedelta(minutes=1)

    return operations


def getRegistry(user, device, time, network):
    latitude, logitude = add_variation_location(-21.7866751, -43.3688584)
    return {
        "TYPE": "REGISTRY",
        "REGISTRY": user['REGISTRY'],
        "IP_ADDRESS": network,
        "LATITUDE": str(latitude),
        "LONGITUDE": str(logitude),
        "MAC": device["MAC"],
        "DFP": device['DFP'],
        "OS": device['OS'],
        "VERSION_OS": device['VERSION_OS'],
        "TIME": time.strftime("%Y-%m-%d %H:%M:%S.%f")
    }

def getLogin(user, device, time, network):
    latitude, logitude = add_variation_location(-21.7866751, -43.3688584)
    return {
        "TYPE": "LOGIN",
        "REGISTRY": user["REGISTRY"],
        "PASSWORD": user['PASSWORD'],
        "IP_ADDRESS": network,
        "LATITUDE": str(latitude),
        "LONGITUDE": str(logitude),
        "MAC": device["MAC"],
        "DFP": device['DFP'],
        "OS": device['OS'],
        "VERSION_OS": device['VERSION_OS'],
        "TIME": time.strftime("%Y-%m-%d %H:%M:%S.%f")
    }

def getAccess(user, device, time, access, network):
    latitude, logitude = add_variation_location(-21.7866751, -43.3688584)
    return {
        "REAUTHENTICATE": True,
        "TYPE": "ACCESS",
        "RESOURCE": access['RESOURCE'],
        "SUB_RESOURCE": access['SUB_RESOURCE'],
        "TYPE_ACTION": access['TYPE_ACTION'],
        "REGISTRY": user["REGISTRY"],
        "IP_ADDRESS": network,
        "LATITUDE": str(latitude),
        "LONGITUDE": str(logitude),
        "MAC": device["MAC"],
        "DFP": device['DFP'],
        "OS": device['OS'],
        "VERSION_OS": device['VERSION_OS'],
        "TIME": time.strftime("%Y-%m-%d %H:%M:%S.%f")
    }

def add_variation_location(lat, lon, max=3):
    lat_meters = np.random.uniform(-max, max)
    lon_meters = np.random.uniform(-max, max)

    lat_degrees = lat_meters / 111320.0

    lon_degrees = lon_meters / (111320.0 * np.cos(np.radians(lat)))

    new_lat = round(lat + lat_degrees, 7)
    new_lon = round(lon + lon_degrees, 7)

    return new_lat, new_lon

def getChangeSignals(registry):
    return {
        "TYPE": "CHANGE_SIGNALS",
        "REGISTRY": registry,
        "MIN": 0,
        "MAX": 94
    }

def changeDevice():
    randInd = random.randint(0, len(alternativeDevice)-1)
    while alternativeDevice[randInd]['MAC'] in devicesUsed:
        randInd = random.randint(0, len(alternativeDevice)-1)
    return randInd

# User data
ind = [5, 15, 17, 20, 32, 35, 48, 49, 50, 59, 63, 68, 77, 83, 88, 92]
userData = [
    {
        "REGISTRY": "460.395.930-32",
        "TYPE_USER": "Profissional",
        "PASSWORD": "URtrE4lfJ7",
        "NAME": "Lucas",
        "POSITION": "Medico",
        "DAYS_WORK": "Wednesday-Thursday-Friday-Saturday-Sunday",
        "START_WORKING_HOURS": "08:00:00",
        "END_WORKING_HOURS": "16:00:00",
        "SIGNAL_INDEX": ind[random.randint(0, 15)]
    },
    {
        "REGISTRY": "649.122.660-35",
        "TYPE_USER": "Profissional",
        "PASSWORD": "ANZWp8ZQUx",
        "NAME": "Ryan",
        "POSITION": "Enfermeiro",
        "DAYS_WORK": "Tuesday-Wednesday-Thursday-Friday-Saturday",
        "START_WORKING_HOURS": "09:00:00",
        "END_WORKING_HOURS": "17:00:00",
        "SIGNAL_INDEX": ind[random.randint(0, 15)]
    },
    {
        "REGISTRY": "859.310.680-31",
        "TYPE_USER": "Profissional",
        "PASSWORD": "EdafPpcqCi",
        "NAME": "Andreia",
        "POSITION": "Atendente",
        "DAYS_WORK": "Sunday-Monday-Tuesday-Wednesday-Thursday",
        "START_WORKING_HOURS": "15:00:00",
        "END_WORKING_HOURS": "02:00:00",
        "SIGNAL_INDEX": ind[random.randint(0, 15)]
    },
    {
        "REGISTRY": "465.994.610-00",
        "TYPE_USER": "Profissional",
        "PASSWORD": "uYXtzgUUGF",
        "NAME": "Clarice",
        "POSITION": "Administrador",
        "DAYS_WORK": "Thursday-Friday-Saturday-Sunday-Monday",
        "START_WORKING_HOURS": "13:00:00",
        "END_WORKING_HOURS": "22:00:00",
        "SIGNAL_INDEX": ind[random.randint(0, 15)]
    },
    {
        "REGISTRY": "773.391.700-06",
        "TYPE_USER": "Paciente",
        "PASSWORD": "6CQ3jhgO1I",
        "NAME": "Flavia",
        "POSITION": "",
        "DAYS_WORK": "",
        "START_WORKING_HOURS": "",
        "END_WORKING_HOURS": "",
        "SIGNAL_INDEX": ind[random.randint(0, 15)]
    }
]

# Devices data
deviceData = [
    {
        "MAC": "CA-14-17-8G-9E-9F",
        "DFP": "29930a0e2ea9e88d47e59571862aaf2c01781cbef7dbac0615e9efe383c8235b",
        "OS": "Windows 10",
        "VERSION_OS": "21H2",
    },
    {
        "MAC": "A0-B3-03-62-93-78",
        "DFP": "96e16df008666828cf392dd319c9fef4554fd6efb15ed5c1bbdb2f5a83eee0f2",
        "OS": "Windows 11",
        "VERSION_OS": "21H1",
    },
    {
        "MAC": "4E-78-AE-A0-FD-68",
        "DFP": "96af49dd71a0ce8283ffe42b861d03ad24e9abfa0c8ae2b941e8837a0447c1d4",
        "OS": "Linux Ubuntu",
        "VERSION_OS": "23.1",
    },
    {
        "MAC": "25-99-65-91-75-9A",
        "DFP": "4f525f37fbc7665313d088ff4eacff885e9b923be8c0b4b0c232f97b73d9dfc4",
        "OS": "MAC_OS",
        "VERSION_OS": "13",
    },
    {
        "MAC": "42-96-01-CB-82-85",
        "DFP": "b16927885648491fb636bfef5cc684463186e1e25f5e1cf0b9ff7ac28b815730",
        "OS": "Android",
        "VERSION_OS": "15",
    }
]
devicesUsed = [deviceData[0]['MAC'], deviceData[1]['MAC'], deviceData[2]['MAC'], deviceData[3]['MAC'], deviceData[4]['MAC']]

alternativeDevice = [
    {
        "MAC": "CB-3D-A6-1C-04-D3",
        "DFP": "ca9cafc948685693000a68cd7f8bcf90d22f51948df75ca22952a39240d46839",
        "OS": "MAC_OS",
        "VERSION_OS": "13",
    },
    {
        "MAC": "CE-4C-1E-DB-A9-FA",
        "DFP": "344f8276003645ac4bf3d8275502f4b3f71cb130f4a6bc3915f2334d9bf668d0",
        "OS": "IOS",
        "VERSION_OS": "16",
    },
    {
        "MAC": "CB-CB-D1-9E-EA-CA",
        "DFP": "e8f5bbe51d07dfd05ba4e3c0d947289fbc3bdca4f9aacf5cef36951a9631cfcd",
        "OS": "Android",
        "VERSION_OS": "15",
    },
    {
        "MAC": "AD-44-14-69-0B-B1",
        "DFP": "ff92c06488f85823c022eca16c5f42797cce5a999456703473c2bb7bbf61e982",
        "OS": "Linux Debian",
        "VERSION_OS": "11.7",
    },
    {
        "MAC": "D3-6E-30-FC-3B-B1",
        "DFP": "b9c9a841c5b2a8bab20d3b24c81ef5814ad3d802af41006e4a808ba82cff7d7d",
        "OS": "Linux Ubuntu",
        "VERSION_OS": "23.1",
    },
    {
        "MAC": "2F-FF-C1-4D-1D-EE",
        "DFP": "b0b4e00d6e1894433b33b9fd3c734e099b3db1cd7b2026477dfe4150d30872eb",
        "OS": "Windows 10",
        "VERSION_OS": "21H2",
    },
    {
        "MAC": "DE-5E-09-EC-D8-9A",
        "DFP": "248b151054e2b94389b5a3442fe11e03b2d9bb5b2c6b564975798eb8c7c7c3e5",
        "OS": "Windows 11",
        "VERSION_OS": "21H1",
    },
    {
        "MAC": "E0-7B-46-CF-C6-AE",
        "DFP": "37b0dd11f072491e0d627d70fe0655fc438a9f77ba9ab88add2b9d5ce31bb71c",
        "OS": "Windows 11",
        "VERSION_OS": "22H2",
    },
    {
        "MAC": "D7-91-0D-ED-E5-2F",
        "DFP": "2de059816c20ee5463c84b0a27a69ad7ebed759baab71cdf5ba8c44cf914dc87",
        "OS": "Android",
        "VERSION_OS": "14",
    },
    {
        "MAC": "5E-7A-F9-94-AF-58",
        "DFP": "289d7cbea33684e9d579b1b5dccf1969356fbcf8a6dcf2932af7b2029153dad2",
        "OS": "Android",
        "VERSION_OS": "15",
    },
    {
        "MAC": "BC-FD-AB-D1-7B-0A",
        "DFP": "b2b7c89e0ab43a3f9dd31ec779c5200858eb2fda2767a438234dda5010171cb3",
        "OS": "Linux Ubuntu",
        "VERSION_OS": "22.1",
    },
    {
        "MAC": "52-38-EE-E2-8D-EF",
        "DFP": "121c8f19c2c6b56111008f60b44778bb551a133f469cffab5205776c7de25fd4",
        "OS": "Linux Debian",
        "VERSION_OS": "11",
    },
    {
        "MAC": "BF-0B-F9-BE-62-A7",
        "DFP": "58e0fcb1b30aa2972fa759015b4b7e4aeb36afa755b27ff1cbdfaa3a41629087",
        "OS": "Windows 11",
        "VERSION_OS": "22H2",
    },
    {
        "MAC": "FA-F5-EE-5E-FA-1D",
        "DFP": "63f76c8d5f51dbc2983c9ede74ebc428d2f8fb5ced0d0903f18b8c3267eefde2",
        "OS": "MAC_OS",
        "VERSION_OS": "13",
    },
    {
        "MAC": "46-AA-86-5A-AB-CC",
        "DFP": "e699d8d8bb94ab2ace3d1aec8faddfe98cfb43e9ce5173535a25c9cd2cfd11e0",
        "OS": "Android",
        "VERSION_OS": "13",
    }
]