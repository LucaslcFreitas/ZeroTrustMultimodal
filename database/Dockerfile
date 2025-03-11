FROM postgres:16.1-alpine

ENV POSTGRES_DB=zt-ehealth
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=zerotrust
ENV TZ=America/Sao_Paulo

RUN mkdir -p /docker-entrypoint-initdb.d

COPY database.sql /docker-entrypoint-initdb.d/