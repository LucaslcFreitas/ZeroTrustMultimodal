FROM python:3.10.9-slim

WORKDIR /app
COPY . .
RUN pip install keras==2.11.0 tensorflow==2.11.0 numpy==1.23.4 pandas scipy watchdog psycopg2-binary

CMD ["python", "/app/StartAutoReload.py"]