#!/bin/bash

## 0 - Configurações

    printf "\n${GREEN}Declarando variáveis...${NC}\n"

        GREEN='\033[0;32m'
        NC='\033[0m'

        db_name="$1"
        root_name="$2"
        root_pass="$3"
        n_cont="$4"

        master_ip=$(hostname -I | awk '{print $1}') 

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

    printf "\n${GREEN}Criando arquivo de configuração do worker...${NC}\n"

        printf "\n\n" >> master_vars.conf
        echo "master_ip=${master_ip}" >> master_vars.conf
        echo "worker_token=${worker_token}" >> master_vars.conf
        echo "manager_token=${manager_token}" >> master_vars.conf

## 1 - Banco de dados

    printf "\n${GREEN}Criando container do mysql_db...${NC}\n"

        docker run -d --name mysql_db \
            -e MYSQL_ROOT_PASSWORD=$root_pass \
            -e MYSQL_DATABASE=$db_name \
            -e MYSQL_USER=$root_name \
            -e MYSQL_PASSWORD=$root_pass \
            -p 3306:3306 \
            -v db_volume:/var/lib/mysql \
            --restart always \
            mysql
        mysql_container_id=$(docker ps --filter "name=mysql_db" --format "{{.ID}}")
        sleep 30

    printf "\n${GREEN}Aplicando o script SQL ao banco de dados...${NC}\n"

        cp -r modules/database/* /var/lib/docker/volumes/db_volume/_data
        docker exec -i $mysql_container_id sh -c "exec mysql -u root -p'$root_pass' $db_name < /var/lib/mysql/dbscript.sql"

## 2 - Proxy

    printf "\n${GREEN}Criando proxy...${NC}\n"
        
        cd modules/proxy || return     
        sed -i "/upstream all/a\        server $master_ip:80;" nginx.conf
        cp nginx.conf /var/lib/docker/volumes/proxy_volume/_data
        cp dockerfile /var/lib/docker/volumes/proxy_volume/_data
        docker build -t nginx_ready .
        cd - || return
        docker run --name nginx_proxy -dti \
            -v proxy_volume \
            --restart=always \
            --network=cluster_network \
            -p 4500:4500 nginx_ready
        sleep 30

        last_num_workers=$(docker node ls -q | xargs docker node inspect -f '{{ .Status.State }}' | grep -c 'ready')

        while true; do

            num_workers=$(docker node ls -q | xargs docker node inspect -f '{{ .Status.State }}' | grep -c 'ready')

            if [ $num_workers -ne $last_num_workers ]; then
                printf "\n${GREEN}Novo worker detectado!${NC}\n"
                    docker stop nginx_proxy
                    docker rm nginx_proxy

                    new_worker_ip=$(tail -n 1 /shared/ip_list.conf | awk -F= '{print $2}')

                    cd /var/lib/docker/volumes/proxy_volume/_data || return
                    sed -i "/upstream all/a\        server $new_worker_ip:80;" nginx.conf
                    docker build -t nginx_ready .
                    docker run --name nginx_proxy -dti \
                        -v proxy_volume \
                        --restart=always \
                        --network=cluster_network \
                        -p 4500:4500 nginx_ready
                    last_num_workers=$num_workers
                    cd - || return
                continue
            fi

            sleep 30s
        
        done & 

        mkdir -p /shared
        printf "# Lista de IPs dos workers do cluster:\n\n" > /shared/ip_list.conf

## 3 - Compartilhamento de arquivos

    printf "\n${GREEN}Compartilhando volume do app via NFS...${NC}\n"

        echo "/var/lib/docker/volumes/app_volume/_data *(rw,sync,subtree_check)" >> /etc/exports
        echo "/shared *(rw,sync,subtree_check)" >> /etc/exports
        exportfs -ar
        systemctl restart nfs-kernel-server

## 4 - Aplicação

    printf "\n${GREEN}Criando imagem configurada...${NC}\n"

        cd modules/app || return
        echo "ENV MASTER_IP=$master_ip" >> Dockerfile
        echo "ENV DB_NAME=$db_name" >> Dockerfile
        echo "ENV ROOT_PASS=$root_pass" >> Dockerfile
        echo "ENV N_RAND_DATA=$n_rand_data" >> Dockerfile
        docker build -t python_ready .
        cd - || return

    printf "\n${GREEN}Copiando arquivos para o volume da aplicação...${NC}\n"

        cp -r modules/app/* /var/lib/docker/volumes/app_volume/_data

    printf "\n${GREEN}Criando serviços do app...${NC}\n"

        docker service create --name python_app_service \
            --mount type=volume,src=app_volume,dst=/var/lib/python \
            --replicas=$n_cont \
            python_ready
        sleep 30