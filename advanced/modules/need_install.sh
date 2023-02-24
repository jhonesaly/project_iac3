#!/bin/bash

printf "\nInstalando Arquivos necessários...\n"

if [ "$ans_a1" = "y" ]; then
    export DEBIAN_FRONTEND=noninteractive
    
    apt-get install docker.io -y -qq
    apt-get install -y docker-compose -qq
    apt-get install mysql-client-core-8.0 -y -qq

    if [ "$ans_a2" = "y" ]; then
        apt-get install -y python3 -qq
        apt-get install -y python3-pip -qq
    fi

    if [ "$ans_a3" = "y" ]; then
        apt-get install nfs-server
    fi
fi