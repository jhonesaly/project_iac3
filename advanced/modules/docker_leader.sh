#!/bin/bash

db_name="$1" 
root_name="$2" 
root_pass="$3"


printf "\nBaixando imagem do MySQL\n"
docker pull mysql

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
