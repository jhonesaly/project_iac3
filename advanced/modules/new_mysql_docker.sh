#!/bin/bash

ans_db1="$1" #docker
ans_db2="$2" #db name
ans_db3="$3" #db username
ans_db4="$4" #db password

# ans_db1="y" #docker
# ans_db2="test1" #db name
# ans_db3="tester" #db username
# ans_db4="senha" #db password

printf "\nInstalando Docker...\n"
apt-get install docker.io -y
sudo apt-get install -y docker-compose

printf "\nBaixando imagem do MySQL\n"
docker pull mysql

printf "\nCriando contêiner MySQL...\n"
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

printf "\nMontando o contêiner MySQL...\n"
docker-compose up -d

# Cria tabela no banco de dados

## Define o caminho completo para o arquivo SQL que será executado
SQL_FILE=/disk2/publica/project_iac3/advanced/modules/dbscript.sql

## Obtém o ID do container do MySQL em execução
MYSQL_CONTAINER_ID=$(docker ps --filter "name=advanced_db_1" --format "{{.ID}}")

docker cp $SQL_FILE $MYSQL_CONTAINER_ID:/dbscript.sql

## Inicia um shell dentro do container do MySQL
docker exec -it $MYSQL_CONTAINER_ID /bin/bash -c "mysql -u$ans_db3 -p$ans_db4 < /dbscript.sql"