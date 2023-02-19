#!/bin/bash

# Instalar o MySQL
sudo apt-get update
sudo apt-get install -y mysql-server

# Executar o script de segurança interativo do MySQL
sudo mysql_secure_installation

# Criar um novo banco de dados
sudo mysql -u root -p -e "CREATE DATABASE nome_do_banco_de_dados;"

# Criar um novo usuário e conceder todos os privilégios ao banco de dados
sudo mysql -u root -p -e "GRANT ALL PRIVILEGES ON nome_do_banco_de_dados.* TO 'nome_do_usuario'@'localhost' IDENTIFIED BY 'senha_do_usuario';"

# Reiniciar o MySQL para aplicar as alterações
sudo service mysql restart
