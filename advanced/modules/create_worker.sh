#!/bin/bash

## 0 - Configurações

    GREEN='\033[0;32m'
    NC='\033[0m'

    printf "\n${GREEN}Declarando variáveis...${NC}\n"

        source master_vars.conf

    printf "\n${GREEN}Instalando pacotes...${NC}\n"

        export DEBIAN_FRONTEND=noninteractive

        apt-get update -y -qq
        apt-get upgrade -y -qq
        apt-get install docker.io -y -qq
        apt-get install nfs-common -y -qq
        apt-get install mysql-client-core-8.0 -y -qq
        systemctl daemon-reexec
        apt-get autoremove -y

        docker pull python

## 1 - Compartilhamento

    printf "\n${GREEN}Adicionando pastas compartilhadas via NFS...${NC}\n"

        docker volume create app_volume
        mkdir -p /var/lib/docker/volumes/app_volume/_data
        mkdir -p /shared
        mount -o v3 $master_ip:/var/lib/docker/volumes/app_volume/_data /var/lib/docker/volumes/app_volume/_data
        mount -o v3 $master_ip:/shared /shared

## 2 - Cluster

    printf "\n${GREEN}Adicionando nó worker ao cluster...${NC}\n" # Necessário já ter um mysql master

        cp /shared/master_vars.conf ./
        source master_vars.conf
        
        docker swarm join --token $worker_token $master_ip:2377
        worker_ip=$(hostname -I | awk '{print $1}')
        hostname=$(hostname)
        echo "worker_ip_${hostname}=${worker_ip}" >> /shared/ip_list.conf
