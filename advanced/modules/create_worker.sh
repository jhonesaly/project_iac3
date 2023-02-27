#!/bin/bash

printf "\nConfigurando... MySQL\n"
db_name="$1"
root_pass="$2"
n_cont="$3"

image=mysql
image_port=3306

service_name=${image}_worker
volume_name=${image}_volume
network_name=${image}_network

printf "\nBaixando imagem do MySQL\n"
docker pull $image


# Script para sincronizar esse volume via NFS

printf "\nIniciando o cluster...\n"
docker swarm init

printf "\nCriando containers do MySQL...\n"
# docker service create --name mysql_worker --replicas 2 --network mysql_network --env MYSQL_DATABASE=test1 --env MYSQL_PASSWORD=123 --env MYSQL_ROOT_PASSWORD=123 --env MYSQL_USER=tester --mount type=volume,src=mysql_volume,dst=/var/lib/mysql -p 3306:3306 mysql:latest
docker service create --name $service_name --replicas $n_cont --network $network_name --env MYSQL_DATABASE=$db_name --env MYSQL_PASSWORD=$db_pass --env MYSQL_ROOT_PASSWORD=$root_pass --env MYSQL_USER=$root_name --mount type=volume,src=$volume_name,dst=/var/lib/mysql -p $image_port:$image_port $image:latest

# echo "version: '3.0'" > docker-compose.yml
# echo "services:" >> docker-compose.yml
# echo "  $service_name:" >> docker-compose.yml
# echo "    image: ${image}:latest" >> docker-compose.yml
# echo "    replicas: $n_cont" >> docker-compose.yml
# echo "    restart: always" >> docker-compose.yml
# echo "    environment:" >> docker-compose.yml
# echo "      MYSQL_ROOT_PASSWORD: $root_pass" >> docker-compose.yml
# echo "      MYSQL_DATABASE: $db_name" >> docker-compose.yml
# echo "    ports:" >> docker-compose.yml
# echo "      - '$image_port:$image_port'" >> docker-compose.yml
# echo "    expose:" >> docker-compose.yml
# echo "      - '$image_port'" >> docker-compose.yml
# echo "    networks:" >> docker-compose.yml
# echo "      - $network_name" >> docker-compose.yml
# echo "    volumes:" >> docker-compose.yml
# echo "      - $volume_name:/var/lib/mysql" >> docker-compose.yml

# docker-compose up -d

sleep 30
