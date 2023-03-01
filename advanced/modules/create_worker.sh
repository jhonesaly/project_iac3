#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

printf "\n${GREEN}Configurando mysql worker...${NC}\n"

    source master_vars.conf
    # vars in master_vars.conf: db_name, root_name, root_pass, master_ip, worker_token, manager_token
    n_cont="$1"

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
    mount -o v3 $master_ip:/var/lib/docker/volumes/app_volume/_data /var/lib/docker/volumes/app_volume/_data

printf "\n${GREEN}Adicionando nó ao cluster...${NC}\n" # Necessário já ter um mysql master

    docker swarm join --token $worker_token

printf "\n${GREEN}Criando serviço de containers do mysql worker...${NC}\n"

    docker service create --name python_app_service \
        --mount type=volume,src=app_volume,dst=/ \
        --replicas=$n_cont \
        --network=cluster_network \
        python
