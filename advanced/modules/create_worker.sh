#!/bin/bash

printf "\nConfigurando... MySQL\n"
db_name="$1"
root_pass="$2"
n_cont="$3"

image=mysql
image_port=3306
volume_name=advanced_mysql_volume
service_name=mysql_worker
network_name=mysql_network

# Script para sincronizar esse volume via NFS

printf "\nIniciando o cluster...\n"
docker swarm init

printf "\nCriando containers do MySQL...\n"
# docker service create --name mysql_worker --replicas 2 --network mysql_network --env MYSQL_DATABASE=test1 --env MYSQL_PASSWORD=123 --env MYSQL_ROOT_PASSWORD=123 --env MYSQL_USER=tester --mount type=volume,src=mysql_volume,dst=/var/lib/mysql -p 3306:3306 mysql:latest
docker service create --name $service_name --replicas $n_cont --network $network_name --env MYSQL_DATABASE=$db_name --env MYSQL_PASSWORD=$db_pass --env MYSQL_ROOT_PASSWORD=$root_pass --env MYSQL_USER=$root_name --mount type=volume,src=$volume_name,dst=/var/lib/mysql -p $image_port:$image_port $image:latest

sleep 30
