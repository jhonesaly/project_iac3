#!/bin/bash

db_name="$1"
db_pass="$2"
root_name="$3"
root_pass="$4"
n_cont="$5"

printf "\nBaixando imagem do MySQL\n"
docker pull mysql

printf "\nCriando serviço do MySQL...\n"

service_volume=dbdata

docker volume create $service_volume

# Script para sincronizar esse volume via NFS

printf "\nIniciando o cluster...\n"

docker swarm init

printf "\nCriando serviço do MySQL...\n"

# docker service create --name mysqldb --replicas 2 --env MYSQL_DATABASE=test1 --env MYSQL_PASSWORD=123 --env MYSQL_ROOT_PASSWORD=123 --env MYSQL_USER=tester --mount type=volume,src=dbdata,dst=/var/lib/mysql -p 3306:3306 mysql:latest
docker service create --name mysqldb --replicas $n_cont --env MYSQL_DATABASE=$db_name --env MYSQL_PASSWORD=$db_pass --env MYSQL_ROOT_PASSWORD=$root_pass --env MYSQL_USER=$root_name --mount type=volume,src=$service_volume,dst=/var/lib/mysql -p 3306:3306 mysql:latest

# echo 'version: "3.0"' > docker-compose.yml
# echo 'services:' >> docker-compose.yml
# echo '  db:' >> docker-compose.yml
# echo '    image: mysql' >> docker-compose.yml
# echo '    restart: always' >> docker-compose.yml
# echo '    environment:' >> docker-compose.yml
# echo "      MYSQL_ROOT_PASSWORD: $root_pass" >> docker-compose.yml
# echo "      MYSQL_DATABASE: $db_name" >> docker-compose.yml
# echo "      MYSQL_USER: $root_name" >> docker-compose.yml
# echo "      MYSQL_PASSWORD: $db_pass" >> docker-compose.yml
# echo '    ports:' >> docker-compose.yml
# echo '      - "3306:3306"' >> docker-compose.yml
# echo '    volumes:' >> docker-compose.yml
# echo '      - ./dbdata:/var/lib/mysql' >> docker-compose.yml

# docker-compose up -d

sleep 30

# Cria tabela no banco de dados
MYSQL_CONTAINER_ID=$(docker ps --filter "name=advanced_db_1" --format "{{.ID}}")
printf "\nO ID do Contêiner é : $MYSQL_CONTAINER_ID\n"

## Inicia um shell dentro do container do MySQL
printf "\nAplicando o script SQL...\n"

# docker cp /disk2/publica/project_iac3/advanced/modules/dbscript.sql $MYSQL_CONTAINER_ID:/dbscript.sql
cp /disk2/publica/project_iac3/advanced/modules/dbscript.sql /var/lib/docker/volumes/dbdata/_data

docker exec -i $MYSQL_CONTAINER_ID sh -c "exec mysql -u root -p'$db_pass' $db_name < /dbscript.sql"
