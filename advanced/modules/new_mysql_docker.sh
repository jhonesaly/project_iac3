#!/bin/bash

ans_db1="$1" #docker
ans_db2="$2" #db name
ans_db3="$3" #db username
ans_db4="$4" #db password


printf "\nInstalando Docker...\n"

apt-get install docker -y
sudo apt-get install -y docker-compose

printf "\nBaixando imagem do MySQL\n"

docker pull mysql

# Inicia o contêiner do MySQL

printf "\nCriando Banco de Dados...\n"

echo 'version: "3.9"' > docker-compose.yml
echo 'services:' >> docker-compose.yml
echo '  db:' >> docker-compose.yml
echo '    image: mysql' >> docker-compose.yml
echo '    restart: always' >> docker-compose.yml
echo '    environment:' >> docker-compose.yml
echo "      MYSQL_ROOT_PASSWORD: $ans_db4" >> docker-compose.yml
echo "      MYSQL_DATABASE: $ans_db2" >> docker-compose.yml
echo "      MYSQL_USER: $ans_db3" >> docker-compose.yml
echo "      MYSQL_PASSWORD: $ans_db4" >> docker-compose.yml
echo '    ports:' >> docker-compose.yml
echo '      - "3306:3306"' >> docker-compose.yml
echo '    volumes:' >> docker-compose.yml
echo '      - ./data:/var/lib/mysql' >> docker-compose.yml

# Substitui o valor "false" por "true" no arquivo de configuração do MySQL
sed -i 's/^.*allowPublicKeyRetrieval.*$/allowPublicKeyRetrieval=true/' /etc/mysql/my.cnf

# Reinicia o serviço do MySQL para que as alterações sejam aplicadas
systemctl restart mysql.service

docker-compose up -d