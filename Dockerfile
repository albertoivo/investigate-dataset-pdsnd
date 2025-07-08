FROM postgres:16-alpine

# Instalar ferramentas necessárias
RUN apk add --no-cache bash

# Copiar o arquivo de dump da base de dados
COPY dvdrental.tar /tmp/dvdrental.tar

# Copiar e dar permissões aos scripts de inicialização
COPY init-db/ /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/*.sh

# Definir variáveis de ambiente (senha será definida no docker-compose)
ENV POSTGRES_DB=dvdrental
ENV POSTGRES_USER=postgres

# Expor porta padrão do PostgreSQL
EXPOSE 5432
