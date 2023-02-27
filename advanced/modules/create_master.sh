#!/bin/bash

printf "\nConfigurando... MySQL\n"
db_name="$1"
root_pass="$2"

image=mysql
image_port=3306
service_name=mysql_master
volume_name=mysql_volume
network_name=mysql_network

printf "\nBaixando imagem do MySQL\n"
docker pull $image

printf "\nCriando serviço e rede do MySQL...\n"
docker volume create $volume_name
docker network create --driver overlay --scope global $network_name
docker swarm init

printf "\nBaixando imagem do MySQL\n"
docker pull mysql

printf "\nCriando contêiner mestre MySQL...\n"

echo "version: '3.9'" > docker-compose.yml
echo "services:" >> docker-compose.yml
echo "  $service_name:" >> docker-compose.yml
echo "    image: $image" >> docker-compose.yml
echo "    restart: always" >> docker-compose.yml
echo "    environment:" >> docker-compose.yml
echo "      MYSQL_ROOT_PASSWORD: $root_pass" >> docker-compose.yml
echo "      MYSQL_DATABASE: $db_name" >> docker-compose.yml
echo "    ports:" >> docker-compose.yml
echo "      - '$image_port:$image_port'" >> docker-compose.yml
echo "    volumes:" >> docker-compose.yml
echo "      - $volume_name:/var/lib/mysql" >> docker-compose.yml
echo "volumes:" >> docker-compose.yml
echo "  - $volume_name:"

printf "\nMontando o contêiner MySQL...\n"
docker-compose up -d
sleep 30

# Cria tabela no banco de dados
MYSQL_CONTAINER_ID=$(docker ps --filter "name=advanced_mysql_master_1" --format "{{.ID}}")
printf "\nO ID do Contêiner é : $MYSQL_CONTAINER_ID\n"

## Inicia um shell dentro do container do MySQL
printf "\nAplicando o script SQL...\n"

# docker cp /disk2/publica/project_iac3/advanced/modules/dbscript.sql $MYSQL_CONTAINER_ID:/dbscript.sql
cp /disk2/publica/project_iac3/advanced/modules/dbscript.sql /var/lib/docker/volumes/dbdata/_data
docker exec -i $MYSQL_CONTAINER_ID sh -c "exec mysql -u root -p'$root_pass' $db_name < /dbscript.sql"