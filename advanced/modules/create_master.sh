#!/bin/bash

printf "\nInstalando Pacotes...\n"

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

printf "\nConfigurando... MySQL\n"
db_name="$1"
root_name="$2"
root_pass="$3"

image=mysql
image_port=3306
volume_name=mysql_volume
service_name=mysql_master
network_name=mysql_network

printf "\nBaixando imagem do MySQL...\n"
docker pull $image

printf "\nCriando docker-compose do mysql mestre...\n"

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

printf "\nMontando o contêiner do mysql mestre...\n"
docker-compose up -d
sleep 30

printf "\nAplicando o script SQL...\n" # Cria tabela no banco de dados
MYSQL_CONTAINER_ID=$(docker ps --filter "name=advanced_mysql_master_1" --format "{{.ID}}")
printf "\nO ID do Contêiner é : $MYSQL_CONTAINER_ID\n"
# docker cp /disk2/publica/project_iac3/advanced/modules/dbscript.sql $MYSQL_CONTAINER_ID:/dbscript.sql
docker cp /disk2/publica/project_iac3/advanced/modules/dbscript.sql $MYSQL_CONTAINER_ID:/dbscript.sql
docker exec -i $MYSQL_CONTAINER_ID sh -c "exec mysql -u root -p'$root_pass' $db_name < /dbscript.sql"

printf "\nCriando rede do mysql...\n" # Cria cluster usando docker swarm
docker swarm init
docker network create --driver overlay --scope global $network_name

printf "\nCompatilhando via NFS...\n" # Compartilha conteúdo dentro do volume
echo "/var/lib/docker/volumes/advanced_mysql_volume/_data *(rw,sync,subtree_check)" >> /etc/exports
exportfs -ar
systemctl restart nfs-kernel-server

printf "\nCriando proxy...\n"
cd proxy
cp nginx.conf /var/lib/docker/volumes/advanced_mysql_volume/_data
docker build -t proxy-app .
docker run --name mysql-proxy -dti -p 4500:4500 proxy-app
