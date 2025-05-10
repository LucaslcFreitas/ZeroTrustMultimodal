import datetime
import random
import json
import os
import numpy as np

# TODO: Variar localização, rede
def getRandomNormal(min):
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
    operations = []

    with open(os.path.dirname(os.path.abspath(__file__)) + resourcesPath) as f:
        resources = json.load(f)

    # Realiza o registro
    operations.append(getRegistry(userData[userInd], deviceData[deviceInd], baseTime))
    baseTime = baseTime + datetime.timedelta(minutes=1)

    # Realiza o login
    operations.append(getLogin(userData[userInd], deviceData[deviceInd], baseTime))
    baseTime = baseTime + datetime.timedelta(minutes=1)


    # Realiza acesso de muito baixa sensibilidade
    if len(resources['veryLowSensivity']) > 0:
        for i in range(15):
            ind = random.randint(0, len(resources['veryLowSensivity'])-1)
            operations.append(getAccess(userData[userInd], deviceData[deviceInd], baseTime, resources['veryLowSensivity'][ind]))
            baseTime = baseTime + datetime.timedelta(minutes=1)

    # Realiza acesso de baixa sensibilidade
    if len(resources['lowSensivity']) > 0:
        for i in range(15):
            ind = random.randint(0, len(resources['lowSensivity'])-1)
            operations.append(getAccess(userData[userInd], deviceData[deviceInd], baseTime, resources['lowSensivity'][ind]))
            baseTime = baseTime + datetime.timedelta(minutes=1)

    # Realiza acesso de média sensibilidade
    if len(resources['mediumSensivity']) > 0:
        for i in range(15):
            ind = random.randint(0, len(resources['mediumSensivity'])-1)
            operations.append(getAccess(userData[userInd], deviceData[deviceInd], baseTime, resources['mediumSensivity'][ind]))
            baseTime = baseTime + datetime.timedelta(minutes=1)

    # Realiza acesso de alta sensibilidade
    if len(resources['highSensivity']) > 0:
        for i in range(5):
            ind = random.randint(0, len(resources['highSensivity'])-1)
            operations.append(getAccess(userData[userInd], deviceData[deviceInd], baseTime, resources['highSensivity'][ind]))
            baseTime = baseTime + datetime.timedelta(minutes=1)
    else:
        for i in range(5):
            ind = random.randint(0, len(resources['mediumSensivity'])-1)
            operations.append(getAccess(userData[userInd], deviceData[deviceInd], baseTime, resources['mediumSensivity'][ind]))
            baseTime = baseTime + datetime.timedelta(minutes=1)

    if min > 50:
        # Realiza acessos normais, de forma aleatória
        resources = resources['veryLowSensivity'] + resources['lowSensivity'] + resources['mediumSensivity'] + resources['highSensivity']
        random.shuffle(resources)

        for i in range(min - 50):
            ind = random.randint(0, len(resources)-1)
            operations.append(getAccess(userData[userInd], deviceData[deviceInd], baseTime, resources[ind]))
            baseTime = baseTime + datetime.timedelta(minutes=1)

    return operations


def getRegistry(user, device, time):
    latitude, logitude = add_variation_location(-21.7866751, -43.3688584)
    return {
        "TYPE": "REGISTRY",
        "REGISTRY": user['REGISTRY'],
        "IP_ADDRESS": "172.16.10.1/24",
        "LATITUDE": str(latitude),
        "LONGITUDE": str(logitude),
        "MAC": device["MAC"],
        "DFP": device['DFP'],
        "OS": device['OS'],
        "VERSION_OS": device['VERSION_OS'],
        "TIME": time.strftime("%Y-%m-%d %H:%M:%S.%f")
    }

def getLogin(user, device, time):
    latitude, logitude = add_variation_location(-21.7866751, -43.3688584)
    return {
        "TYPE": "LOGIN",
        "REGISTRY": user["REGISTRY"],
        "PASSWORD": user['PASSWORD'],
        "IP_ADDRESS": "172.16.10.1/24",
        "LATITUDE": str(latitude),
        "LONGITUDE": str(logitude),
        "MAC": device["MAC"],
        "DFP": device['DFP'],
        "OS": device['OS'],
        "VERSION_OS": device['VERSION_OS'],
        "TIME": time.strftime("%Y-%m-%d %H:%M:%S.%f")
    }

def getAccess(user, device, time, access):
    latitude, logitude = add_variation_location(-21.7866751, -43.3688584)
    return {
        "REAUTHENTICATE": True,
        "TYPE": "ACCESS",
        "RESOURCE": access['RESOURCE'],
        "SUB_RESOURCE": access['SUB_RESOURCE'],
        "TYPE_ACTION": access['TYPE_ACTION'],
        "REGISTRY": user["REGISTRY"],
        "IP_ADDRESS": "172.16.10.1/24",
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

# User data
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
        "SIGNAL_INDEX": random.randint(0, 94)
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
        "SIGNAL_INDEX": random.randint(0, 94)
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
        "SIGNAL_INDEX": random.randint(0, 94)
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
        "SIGNAL_INDEX": random.randint(0, 94)
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
        "SIGNAL_INDEX": random.randint(0, 94)
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
