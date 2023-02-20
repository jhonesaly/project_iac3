#!/bin/bash

ans_db1="$1" #docker
ans_db2="$2" #db name
ans_db3="$3" #db username
ans_db4="$4" #db password

printf "\nInstalando MySql...\n"

# Instalar o MySQL
apt-get update
apt-get install mysql -y
apt-get install mysql-server -y
## Criar um novo banco de dados
printf "\nCriando Banco de Dados...\n"

mysql -u root -p -e "CREATE DATABASE $ans_db2;"

## Criar um novo usuário e conceder todos os privilégios ao banco de dados
mysql -u root -p -e "GRANT ALL PRIVILEGES ON *.* TO '$ans_db3'@'localhost' IDENTIFIED BY '$ans_db4';"

## Reiniciar o MySQL para aplicar as alterações
service mysql restart