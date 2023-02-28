#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

printf "\n${GREEN}Configurando mysql worker...${NC}\n"

    source master_vars.conf

    # vars in master_vars.conf: db_name, root_name, root_pass, master_ip, worker_token

    image=mysql
    image_port=3306
    volume_name=advanced_mysql_volume
    service_name=mysql_worker
    network_name=advanced_default

printf "\n${GREEN}Instalando pacotes...${NC}\n"

    export DEBIAN_FRONTEND=noninteractive

    apt-get update
    apt-get install docker.io -y -qq
    apt-get install mysql-client-core-8.0 -y -qq
    apt-get install nfs-common -y -qq
    systemctl daemon-reexec
    apt-get autoremove -y

printf "\n${GREEN}Adicionando nó ao cluster...${NC}\n" # Necessário já ter um mysql master

    docker swarm join --token $worker_token

printf "\n${GREEN}Adicionando pasta compartilhada com o master via NFS...${NC}\n"

    mount -o v3 $master_ip:/var/lib/docker/volumes/advanced_mysql_volume/_data /var/lib/docker/volumes/advanced_mysql_volume/_data

printf "\n${GREEN}Criando serviço de containers do mysql worker...${NC}\n"
    # docker service create --name mysql_worker --replicas 2 --network mysql_network --env MYSQL_DATABASE=test1 --env MYSQL_PASSWORD=123 --env MYSQL_ROOT_PASSWORD=123 --env MYSQL_USER=tester --mount type=volume,src=mysql_volume,dst=/var/lib/mysql -p 3306:3306 mysql:latest
    docker service create --name $service_name \
    --replicas $n_cont \
    --network $network_name \
    --env MYSQL_DATABASE=$db_name \
    --env MYSQL_PASSWORD=$root_pass \
    --env MYSQL_ROOT_PASSWORD=$root_pass \
    --env MYSQL_USER=$root_name \
    --mount type=volume,src=$volume_name,dst=/var/lib/mysql \
    -p $image_port:$image_port $image:latest

    sleep 60

printf "\n${GREEN}Adicionando ip do worker ao proxy...${NC}\n"
    # Get IP address of worker machine
    worker_ip=$(hostname -I | awk '{print $1}')
    # Use sed to replace the commented line in nginx.conf with the worker IP
    sed -i "/upstream all/a\  server $worker_ip\n" /var/lib/docker/volumes/advanced_mysql_volume/_data/nginx.conf