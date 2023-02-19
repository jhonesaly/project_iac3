#!/bin/bash

ans_db1="$1" #docker
ans_db2="$2" #db name
ans_db3="$3" #db username
ans_db4="$4" #db password

# Cria o arquivo docker-compose.yml
cat << EOF > docker-compose.yml
version: '3.9'
services:
db:
    image: mysql
    restart: always
    environment:
        MYSQL_ROOT_PASSWORD: $ans_db4
        MYSQL_DATABASE: $ans_db2
        MYSQL_USER: $ans_db3
        MYSQL_PASSWORD: $ans_db4
    ports:
        - "3306:3306"
    volumes:
        - ./data:/var/lib/mysql
EOF

if [ "$ans_db1" = "y" ]; then
    printf "\nInstalando Docker...\n"
    
    apt-get install docker
    sudo apt-get update
    sudo apt-get install -y docker-compose

    printf "\nBaixando imagem do MySQL\n"

    docker pull mysql

    # Inicia o contêiner do MySQL

    sudo docker-compose up -d

elif [ "$ans_db1" = "y" ]; then
    # Instalar o MySQL
    sudo apt-get update
    sudo apt-get install -y mysql-server

    # Executar o script de segurança interativo do MySQL
    sudo mysql_secure_installation

    # Criar um novo banco de dados
    sudo mysql -u root -p -e "CREATE DATABASE $ans_db2;"

    # Criar um novo usuário e conceder todos os privilégios ao banco de dados
    sudo mysql -u root -p -e "GRANT ALL PRIVILEGES ON $ans_db2.* TO '$ans_db3'@'localhost' IDENTIFIED BY '$ans_db4';"

    # Reiniciar o MySQL para aplicar as alterações
    sudo service mysql restart

fi




