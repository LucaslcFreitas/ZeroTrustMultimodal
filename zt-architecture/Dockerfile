FROM python:3.12.3-slim

WORKDIR /app
COPY . .
RUN pip install geopy psycopg2-binary watchdog

CMD ["python", "/app/StartAutoReload.py"]