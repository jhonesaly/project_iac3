#!/bin/bash

db_name="$1" 
root_name="$2" 
root_pass="$3"
n_cont="$4"

printf "\nBaixando imagem do MySQL\n"
docker pull mysql

printf "\nInicializando o cluster Docker Swarm...\n"
docker swarm init

echo "version: '3.9'
services:
  db:
    image: mysql
    deploy:
      replicas: $n_cont
    environment:
      MYSQL_ROOT_PASSWORD: $root_pass
      MYSQL_DATABASE: $db_name
      MYSQL_USER: $root_name
      MYSQL_PASSWORD: $root_pass
    ports:
      - '3306:3306'
    volumes:
      - 'data:/var/lib/mysql'
    restart_policy:
      condition: on-failure
volumes:
  mysql-data:" >> docker-compose.yml


printf "\nCriando serviço do MySQL...\n"
docker stack deploy -c docker-compose.yml mysql

sleep 60

# Cria tabela no banco de dados
MYSQL_CONTAINER_ID=$(docker ps --filter "name=mysql_db." --format "{{.ID}}")
printf "\nO ID do primeiro contêiner é : $MYSQL_CONTAINER_ID\n"

## Inicia um shell dentro do container do MySQL
printf "\nAplicando o script SQL...\n"
docker cp /disk2/publica/project_iac3/advanced/modules/dbscript.sql $MYSQL_CONTAINER_ID:/dbscript.sql
docker exec -i $MYSQL_CONTAINER_ID sh -c "exec mysql -u root -p'$root_pass' $db_name < /dbscript.sql"