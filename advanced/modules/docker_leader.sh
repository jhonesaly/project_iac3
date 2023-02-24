#!/bin/bash

db_name="$1"
root_name="$2"
root_pass="$3"
n_cont="$4"

printf "\nBaixando imagem do MySQL\n"
docker pull mysql

# Define a porta base
PORT_BASE=3306

# Define o nome do serviço
SERVICE_NAME=db

# Cria o arquivo docker-compose.yml
echo "version: '3.9'
services:
  $SERVICE_NAME:"

# Loop para criar cada contêiner
for (( i=1; i<=$n_cont; i++ )); do
    # Define a porta para esse contêiner
    PORT=$((PORT_BASE + i - 1))

    echo "  db$i:
    image: mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: ${root_pass}
      MYSQL_DATABASE: ${db_name}
      MYSQL_USER: ${root_name}
      MYSQL_PASSWORD: ${root_pass}
    ports:
      - \"$PORT:3306\"
    volumes:
      - ./data$i:/var/lib/mysql
    deploy:
      replicas: 1
      placement:
        constraints:
          - node.role == worker"
done > docker-compose.yml

# Cria as pastas para os volumes
for (( i=1; i<=$n_cont; i++ )); do
  mkdir -p ./data$i
done

printf "\nMontando o contêiner MySQL...\n"
docker-compose up -d
sleep 30

# Cria tabela no banco de dados

MYSQL_CONTAINER_ID=$(docker ps --filter "name=advanced_db_1" --format "{{.ID}}")
printf "\nO ID do Contêiner é : $MYSQL_CONTAINER_ID\n"

## Inicia um shell dentro do container do MySQL
printf "\nAplicando o script SQL...\n"
docker cp /disk2/publica/project_iac3/advanced/modules/dbscript.sql $MYSQL_CONTAINER_ID:/dbscript.sql
docker exec -i $MYSQL_CONTAINER_ID sh -c "exec mysql -u root -p'$root_pass' $db_name < /dbscript.sql"