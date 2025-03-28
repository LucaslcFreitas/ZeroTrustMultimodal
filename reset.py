import psycopg2
import os
import json

def resetDatabase(host, port, database, user, password):
    conn = psycopg2.connect(
        host=host,
        port=port,
        database=database,
        user=user,
        password=password
    )
    cursor = conn.cursor()

    with open(os.path.dirname(os.path.abspath(__file__)) + '/reset.sql') as resetFile:
        script = resetFile.read()

    cursor.execute(script)

    conn.commit()
    conn.close()