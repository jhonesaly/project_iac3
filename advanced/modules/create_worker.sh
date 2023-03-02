#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

printf "\n${GREEN}Configurando mysql worker...${NC}\n"

    source master_vars.conf
    # vars in master_vars.conf: db_name, root_name, root_pass, master_ip, worker_token, manager_token

printf "\n${GREEN}Instalando pacotes...${NC}\n"

    export DEBIAN_FRONTEND=noninteractive

    apt-get update -y -qq
    apt-get upgrade -y -qq
    apt-get install docker.io -y -qq
    apt-get install nfs-common -y -qq
    systemctl daemon-reexec
    apt-get autoremove -y

    docker pull python

printf "\n${GREEN}Adicionando pasta compartilhada com o master via NFS...${NC}\n"

    docker volume create app_volume
    mkdir -p /var/lib/docker/volumes/app_volume/_data
    mkdir -p /shared
    mount -o v3 $master_ip:/var/lib/docker/volumes/app_volume/_data /var/lib/docker/volumes/app_volume/_data
    mount -o v3 $master_ip:/shared /shared

printf "\n${GREEN}Adicionando nó ao cluster...${NC}\n" # Necessário já ter um mysql master

    docker swarm join --token $worker_token $master_ip:2377
    worker_ip=$(hostname -I | awk '{print $1}')
    hostname=$(hostname)
    echo "worker_ip_$(hostname)=${worker_ip}" >> /shared/ip_list.conf

