#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

printf "\n${GREEN}Configurando mysql master...${NC}\n"

    db_name="$1"
    root_name="$2"
    root_pass="$3"

    image=mysql
    image_port=3306
    volume_name=mysql_volume
    service_name=mysql_master
    network_name=mysql_network

printf "\n${GREEN}Instalando pacotes...${NC}\n"

    export DEBIAN_FRONTEND=noninteractive

    apt-get update
    apt-get install docker.io -y -qq
    apt-get install -y docker-compose -qq
    apt-get install mysql-client-core-8.0 -y -qq
    apt-get install -y python3 -qq
    apt-get install -y python3-pip -qq
    apt-get install nfs-server -y -qq
    apt-get install -y nfs-kernel-server -y -qq

    systemctl daemon-reexec
    apt-get autoremove -y

    docker pull $image

printf "\n${GREEN}Criando container do mysql mestre...${NC}\n"

    echo "version: '3.9'" > docker-compose.yml
    echo "services:" >> docker-compose.yml
    echo "  $service_name:" >> docker-compose.yml
    echo "    image: $image" >> docker-compose.yml
    echo "    restart: always" >> docker-compose.yml
    echo "    environment:" >> docker-compose.yml
    echo "      MYSQL_ROOT_PASSWORD: $root_pass" >> docker-compose.yml
    echo "      MYSQL_DATABASE: $db_name" >> docker-compose.yml
    echo "      MYSQL_USER: $root_name" >> docker-compose.yml
    echo "      MYSQL_PASSWORD: $root_pass" >> docker-compose.yml
    echo "    ports:" >> docker-compose.yml
    echo "      - '$image_port:$image_port'" >> docker-compose.yml
    echo "    volumes:" >> docker-compose.yml
    echo "      - $volume_name:/var/lib/mysql" >> docker-compose.yml
    echo "volumes:" >> docker-compose.yml
    echo "  $volume_name:" >> docker-compose.yml

    docker-compose up -d
    sleep 60

printf "\n${GREEN}Aplicando o script SQL ao banco de dados...${NC}\n"

    MYSQL_CONTAINER_ID=$(docker ps --filter "name=advanced_mysql_master_1" --format "{{.ID}}")
    printf "\nO ID do Contêiner é : $MYSQL_CONTAINER_ID\n"
    # docker cp /disk2/publica/project_iac3/advanced/modules/dbscript.sql $MYSQL_CONTAINER_ID:/dbscript.sql
    docker cp /disk2/publica/project_iac3/advanced/modules/dbscript.sql $MYSQL_CONTAINER_ID:/dbscript.sql
    docker exec -i $MYSQL_CONTAINER_ID sh -c "exec mysql -u root -p'$root_pass' $db_name < /dbscript.sql"

printf "\n${GREEN}Criando cluster e rede do mysql...${NC}\n"

    docker swarm init
    docker network create --driver overlay --scope global $network_name

printf "\n${GREEN}Compartilhando volume via NFS...${NC}\n"

    echo "/var/lib/docker/volumes/advanced_mysql_volume/_data *(rw,sync,subtree_check)" >> /etc/exports
    exportfs -ar
    systemctl restart nfs-kernel-server

printf "\n${GREEN}Criando proxy...${NC}\n"

    cd proxy || return
    cp nginx.conf /var/lib/docker/volumes/advanced_mysql_volume/_data
    docker build -t proxy-app .
    docker run --name nginx_proxy -dti -p 4500:4500 proxy-app

printf "\n${GREEN}Criando arquivo de configuração do worker...${NC}\n"

    master_ip=$(ip addr show | grep -E "inet .*brd" | awk '{print $2}' | cut -d '/' -f1 | head -n1) 
    worker_token=$(docker swarm join-token worker -q)

    echo "db_name=${db_name}" > master_vars.conf
    echo "root_name=${root_name}" >> master_vars.conf
    echo "root_pass=${root_pass}" >> master_vars.conf
    echo "master_ip=${master_ip}" >> master_vars.conf
    echo "worker_token=${worker_token}" >> master_vars.conf