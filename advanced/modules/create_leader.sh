#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

printf "\n${GREEN}Configurando mysql master...${NC}\n"

    db_name="$1"
    root_name="$2"
    root_pass="$3"

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

    docker pull mysql
    docker pull python
    docker pull nginx

printf "\n${GREEN}Criando volumes...${NC}\n"

    docker volume create db_volume
    docker volume create app_volume
    docker volume create proxy_volume

printf "\n${GREEN}Criando cluster e sua rede...${NC}\n"

    docker swarm init
    worker_token=$(docker swarm join-token worker -q)
    manager_token=$(docker swarm join-token manager -q)
    docker network create cluster_network


printf "\n${GREEN}Criando container do mysql_db...${NC}\n"

    docker run -d --name mysql_db \
        -e MYSQL_ROOT_PASSWORD=$root_pass \
        -e MYSQL_DATABASE=$db_name \
        -e MYSQL_USER=$root_name \
        -e MYSQL_PASSWORD=$root_pass \
        -p 3306:3306 \
        -v db_volume:/var/lib/mysql \
        --network cluster_network \
        mysql
    printf "\nO ID do mysql_db é: $mysql_container_id\n"

printf "\n${GREEN}Aplicando o script SQL ao banco de dados...${NC}\n"

    mysql_container_id=$(docker ps --filter "name=mysql_db" --format "{{.ID}}")
    docker cp modules/database/* $mysql_container_id:
    docker exec -i $mysql_container_id sh -c "exec mysql -u root -p'$root_pass' $db_name < /dbscript.sql"

printf "\n${GREEN}Criando container do python_app...${NC}\n"

    docker run -d --name python_app \
        -v app_volume:/app \
        --network cluster_network \
        python
    printf "\nO ID do advanced_python_app é: $python_container_id\n"

printf "\n${GREEN}Criando aplicação no container...${NC}\n"

    python_container_id=$(docker ps --filter "name=advanced_python_app_1" --format "{{.ID}}")
    docker cp modules/app/* $python_container_id:

printf "\n${GREEN}Compartilhando volume do app via NFS...${NC}\n"

    cp app/* /var/lib/docker/volumes/advanced_app/_data
    echo "/var/lib/docker/volumes/advanced_app/_data *(rw,sync,subtree_check)" >> /etc/exports
    exportfs -ar
    systemctl restart nfs-kernel-server

printf "\n${GREEN}Criando proxy...${NC}\n"
    
    cd modules/proxy || return
    master_ip=$(hostname -I | awk '{print $1}')      
    sed -i "/upstream all/a\        server $master_ip:80;" nginx.conf
    cp nginx.conf /var/lib/docker/volumes/proxy_volume/_data
    docker build -t nginx_configured .
    cd ..
    cd ..
    docker run --name nginx_proxy -dti --mount type=volume,src=proxy_volume,dst=/ -p 4500:4500 nginx_configured

    last_num_workers=$(docker node ls | grep -c 'Ready\s*Active\s*Worker')

    while true; do

        num_workers=$(docker node ls | grep -c 'Ready\s*Active\s*Worker')

        if [ $num_workers -ne $last_num_workers ]; then
            printf "\n${GREEN}Novo worker detectado...${NC}\n"
                docker stop nginx_proxy
                docker rm nginx_proxy
                docker build -t nginx_configured .
                docker run --name nginx_proxy -dti --mount type=volume,src=proxy_volume,dst=/ -p 4500:4500 nginx_configured
                last_num_workers=num_workers
            continue
        fi

        sleep 60s
    
    done & 


printf "\n${GREEN}Criando arquivo de configuração do worker...${NC}\n"

    echo "db_name=${db_name}" > master_vars.conf
    echo "root_name=${root_name}" >> master_vars.conf
    echo "root_pass=${root_pass}" >> master_vars.conf
    echo "master_ip=${master_ip}" >> master_vars.conf
    echo "worker_token=${worker_token}" >> master_vars.conf
    echo "manager_token=${manager_token}" >> master_vars.conf
