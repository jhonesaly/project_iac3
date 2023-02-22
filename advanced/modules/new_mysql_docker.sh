#!/bin/bash

db_name="$1"
root_name="$2"
root_pass="$3"

printf "\nInstalando Docker...\n"
export DEBIAN_FRONTEND=noninteractive
apt-get install docker.io -y -qq
apt-get install -y docker-compose -qq
apt-get install mysql-client-core-8.0 -y -qq

printf "\nBaixando imagem do MySQL\n"
docker pull mysql

printf "\nCriando contêiner MySQL...\n"
echo 'version: "3.9"' > docker-compose.yml
echo 'services:' >> docker-compose.yml
echo '  db:' >> docker-compose.yml
echo '    image: mysql' >> docker-compose.yml
echo '    restart: always' >> docker-compose.yml
echo '    environment:' >> docker-compose.yml
echo "      MYSQL_ROOT_PASSWORD: $root_pass" >> docker-compose.yml
echo "      MYSQL_DATABASE: $db_name" >> docker-compose.yml
echo "      MYSQL_USER: $root_name" >> docker-compose.yml
echo "      MYSQL_PASSWORD: $root_pass" >> docker-compose.yml
echo '    ports:' >> docker-compose.yml
echo '      - "3306:3306"' >> docker-compose.yml
echo '    volumes:' >> docker-compose.yml
echo '      - ./data:/var/lib/mysql' >> docker-compose.yml

printf "\nMontando o contêiner MySQL...\n"
docker-compose up -d
sleep 30

# Cria tabela no banco de dados

## Define o caminho completo para o arquivo SQL que será executado
SQL_FILE=/disk2/publica/project_iac3/advanced/modules/dbscript.sql

## Obtém o ID do container do MySQL em execução
MYSQL_CONTAINER_ID=$(docker ps --filter "name=advanced_db_1" --format "{{.ID}}")

printf "\nO ID do Contêiner é : $MYSQL_CONTAINER_ID\n"

## Inicia um shell dentro do container do MySQL
docker exec -i $MYSQL_CONTAINER_ID mysql -u root -p$root_pass $db_name < $SQL_FILE