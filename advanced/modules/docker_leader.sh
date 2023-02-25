#!/bin/bash

db_name="$1"
db_pass="$2"
root_name="$3"
root_pass="$4"
n_cont="$5"

printf "\nBaixando imagem do MySQL\n"
docker pull mysql

printf "\nInicializando o cluster Docker Swarm...\n"
docker swarm init

mkdir mysql-data

echo "version: '3.0'
services:
  db:
    image: mysql
    deploy:
      replicas: $n_cont
    environment:
      MYSQL_DATABASE: $db_name
      MYSQL_PASSWORD: $db_pass
      MYSQL_USER: $root_name
      MYSQL_ROOT_PASSWORD: $root_pass
    ports:
      - '3306:3306'
    volumes:
      - 'mysql-data:/var/lib/mysql'
volumes:
  mysql-data:
    driver: local
    driver_opts:
      type: none
      device: /disk2/publica/project_iac3/advanced/data
      o: bind" >> docker-compose.yml


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