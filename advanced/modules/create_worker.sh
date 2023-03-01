#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

printf "\n${GREEN}Configurando mysql worker...${NC}\n"

    source master_vars.conf
    # vars in master_vars.conf: db_name, root_name, root_pass, master_ip, worker_token, manager_token

printf "\n${GREEN}Instalando pacotes...${NC}\n"

    export DEBIAN_FRONTEND=noninteractive

    apt-get update
    apt-get install docker.io -y -qq
    apt-get install mysql-client-core-8.0 -y -qq
    apt-get install nfs-common -y -qq
    systemctl daemon-reexec
    apt-get autoremove -y

printf "\n${GREEN}Adicionando pasta compartilhada com o master via NFS...${NC}\n"

    mount -o v3 $master_ip:/var/lib/docker/volumes/advanced_app/_data /var/lib/docker/volumes/advanced_app/_data

printf "\n${GREEN}Adicionando nó ao cluster...${NC}\n" # Necessário já ter um mysql master

    docker swarm join --token $worker_token

printf "\n${GREEN}Criando serviço de containers do mysql worker...${NC}\n"

    echo "version: '3.9'" > docker-compose.yml
    echo "services:" >> docker-compose.yml
    echo "  python_app:" >> docker-compose.yml
    echo "    image: python" >> docker-compose.yml
    echo "    restart: always" >> docker-compose.yml
    echo "    deploy:" >> docker-compose.yml
    echo "      replicas: 3" >> docker-compose.yml
    echo "    volumes:" >> docker-compose.yml
    echo "      - app" >> docker-compose.yml
    echo "    networks:" >> docker-compose.yml
    echo "      - cluster_network" >> docker-compose.yml
    echo "  nginx_proxy:" >> docker-compose.yml
    echo "    image: nginx" >> docker-compose.yml
    echo "    restart: always" >> docker-compose.yml
    echo "    deploy:" >> docker-compose.yml
    echo "      replicas: 1" >> docker-compose.yml
    echo "    networks:" >> docker-compose.yml
    echo "      - cluster_network" >> docker-compose.yml
    echo "volumes:" >> docker-compose.yml
    echo "  app:" >> docker-compose.yml
    echo "networks:" >> docker-compose.yml
    echo "  cluster_network:" >> docker-compose.yml

    docker-compose up -d
    sleep 60

printf "\n${GREEN}Adicionando ip do worker ao proxy...${NC}\n"
    worker_ip=$(hostname -I | awk '{print $1}')
    sed -i "/upstream all/a\        server $worker_ip:80;" /var/lib/docker/volumes/advanced_mysql_volume/_data/nginx.conf