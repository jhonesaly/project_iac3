#!/bin/bash

printf "\nConfigurando... MySQL\n"
db_name="$1"
root_pass="$2"
n_cont="$3"

image=mysql
image_port=3306

service_name=${image}_service
volume_name=${image}_volume
network_name=${image}_network

printf "\nBaixando imagem do MySQL\n"
docker pull $image

printf "\nCriando serviço e rede do MySQL...\n"
docker volume create $service_volume
docker network create --driver overlay --scope global $network_name

# Script para sincronizar esse volume via NFS

printf "\nIniciando o cluster...\n"
docker swarm init

printf "\nCriando infra do MySQL...\n"
# docker service create --name mysql_service --replicas 2 --network mysql_network --env MYSQL_DATABASE=test1 --env MYSQL_PASSWORD=123 --env MYSQL_ROOT_PASSWORD=123 --env MYSQL_USER=tester --mount type=volume,src=mysql_volume,dst=/var/lib/mysql -p 3306:3306 mysql:latest
# docker service create --name $service_name --replicas $n_cont --network $network_name --env MYSQL_DATABASE=$db_name --env MYSQL_PASSWORD=$db_pass --env MYSQL_ROOT_PASSWORD=$root_pass --env MYSQL_USER=$root_name --mount type=volume,src=$volume_name,dst=/var/lib/mysql -p $image_port:$image_port $image:latest

echo "version: '3.0'" > docker-compose.yml
echo "services:" >> docker-compose.yml
echo "  $service_name:" >> docker-compose.yml
echo "    image: ${image}:latest" >> docker-compose.yml
echo "    replicas: $n_cont" >> docker-compose.yml
echo "    restart: always" >> docker-compose.yml
echo "    environment:" >> docker-compose.yml
echo "      MYSQL_ROOT_PASSWORD: $root_pass" >> docker-compose.yml
echo "      MYSQL_DATABASE: $db_name" >> docker-compose.yml
echo "    ports:" >> docker-compose.yml
echo "      - '$image_port:$image_port'" >> docker-compose.yml
echo "    expose:" >> docker-compose.yml
echo "      - '$image_port'" >> docker-compose.yml
echo "    networks:" >> docker-compose.yml
echo "      - $network_name" >> docker-compose.yml
echo "    volumes:" >> docker-compose.yml
echo "      - $volume_name:/var/lib/mysql" >> docker-compose.yml

docker-compose up -d

sleep 30

# Cria tabela no banco de dados
MYSQL_CONTAINER_ID=$(docker ps --filter "name=advanced_db_1" --format "{{.ID}}")
printf "\nO ID do Contêiner é : $MYSQL_CONTAINER_ID\n"

## Inicia um shell dentro do container do MySQL
printf "\nAplicando o script SQL...\n"

# docker cp /disk2/publica/project_iac3/advanced/modules/dbscript.sql $MYSQL_CONTAINER_ID:/dbscript.sql
cp /disk2/publica/project_iac3/advanced/modules/dbscript.sql /var/lib/docker/volumes/dbdata/_data
docker exec -i $MYSQL_CONTAINER_ID sh -c "exec mysql -u root -p'$db_pass' $db_name < /dbscript.sql"
