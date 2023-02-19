#!/bin/bash

ans_db1="$1" #docker
ans_db2="$2" #db name
ans_db3="$3" #db username
ans_db4="$4" #db password

# Cria o arquivo docker-compose.yml

if [ "$ans_db1" = "y" ]; then
    printf "\nInstalando Docker...\n"
    
    apt-get install docker -y
    sudo apt-get update -y
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

    sudo docker-compose up -d

elif [ "$ans_db1" = "n" ]; then
    printf "\nInstalando MySql...\n"
    # Instalar o MySQL
    sudo apt-get update
    sudo apt-get install -y mysql-server
    sudo mysql_secure_installation

    ## Criar um novo banco de dados
    printf "\nCriando Banco de Dados...\n"
    
    sudo mysql -u root -p -e "CREATE DATABASE $ans_db2;"

    ## Criar um novo usuário e conceder todos os privilégios ao banco de dados
    sudo mysql -u root -p -e "GRANT ALL PRIVILEGES ON $ans_db2.* TO '$ans_db3'@'localhost' IDENTIFIED BY '$ans_db4';"

    ## Reiniciar o MySQL para aplicar as alterações
    sudo service mysql restart

fi