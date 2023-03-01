#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

printf "\n${GREEN}Configurando mysql master...${NC}\n"

    db_name="$1"
    root_name="$2"
    root_pass="$3"

printf "\n${GREEN}Instalando pacotes...${NC}\n"

    export DEBIAN_FRONTEND=noninteractive

    apt-get update -y -qq
    apt-get upgrade -y -qq
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
        --restart=always \
        --network=cluster_network \
        mysql
    mysql_container_id=$(docker ps --filter "name=mysql_db" --format "{{.ID}}")
    sleep 30

    printf "\nO ID do container é: $mysql_container_id\n"

printf "\n${GREEN}Aplicando o script SQL ao banco de dados...${NC}\n"

    cp -r modules/database/* /var/lib/docker/volumes/db_volume/_data
    docker exec -i $mysql_container_id sh -c "exec mysql -u root -p'$root_pass' $db_name < /var/lib/mysql/dbscript.sql"

printf "\n${GREEN}Criando container do python_app...${NC}\n"

    docker run -dti --name python_app \
        -v app_volume \
        --restart=always \
        --network=cluster_network \
        python
    python_container_id=$(docker ps --filter "name=python_app" --format "{{.ID}}")
    sleep 30

    printf "\nO ID do container é: $python_container_id\n"
    
printf "\n${GREEN}Criando aplicação no container...${NC}\n"

    cp -r modules/app/* /var/lib/docker/volumes/app_volume/_data

printf "\n${GREEN}Compartilhando volume do app via NFS...${NC}\n"

    cp -r modules/app/* /var/lib/docker/volumes/app_volume/_data
    echo "/var/lib/docker/volumes/app_volume/_data *(rw,sync,subtree_check)" >> /etc/exports
    exportfs -ar
    systemctl restart nfs-kernel-server

printf "\n${GREEN}Criando proxy...${NC}\n"
    
    cd modules/proxy || return
    master_ip=$(hostname -I | awk '{print $1}')      
    sed -i "/upstream all/a\        server $master_ip:80;" nginx.conf
    cp nginx.conf /var/lib/docker/volumes/proxy_volume/_data
    cp dockerfile /var/lib/docker/volumes/proxy_volume/_data
    docker build -t nginx_configured .
    cd - || return
    docker run --name nginx_proxy -dti \
        -v proxy_volume \
        --restart=always \
        --network=cluster_network \
        -p 4500:4500 nginx_configured
    sleep 30

    last_num_workers=$(docker node ls -q | xargs docker node inspect -f '{{ .Status.State }}' | grep -c 'ready')

    while true; do

        num_workers=$(docker node ls -q | xargs docker node inspect -f '{{ .Status.State }}' | grep -c 'ready')

        if [ -n "$num_workers" ] && [ "$(expr "$num_workers" : '^[0-9]*$')" -gt 0 ] && [ $num_workers -ne $last_num_workers ]; then
            printf "\n${GREEN}Novo worker detectado!${NC}\n"
                docker stop nginx_proxy
                docker rm nginx_proxy

                # coletando info do novo worker
                new_worker_id=$(docker node ls -q | xargs docker node inspect -f '{{ .ID }}' | head -n 1)
                new_worker_ip=$(docker node inspect --format '{{ .Status.Addr }}' $new_worker_id)

                cd /var/lib/docker/volumes/proxy_volume/_data || return
                sed -i "/upstream all/a\        server $new_worker_ip:80;" nginx.conf
                docker build -t nginx_configured .
                docker run --name nginx_proxy -dti \
                    -v proxy_volume \
                    --restart=always \
                    --network=cluster_network \
                    -p 4500:4500 nginx_configured
                last_num_workers=num_workers
                cd - || return
            continue
        fi

        sleep 30s
    
    done & 

printf "\n${GREEN}Criando arquivo de configuração do worker...${NC}\n"

    echo "master_ip=${master_ip}" >> master_vars.conf
    echo "worker_token=${worker_token}" >> master_vars.conf
    echo "manager_token=${manager_token}" >> master_vars.conf
