#!/bin/bash

db_name="$1"
db_pass="$2"
root_name="$3"
root_pass="$4"
n_cont="$5"

printf "\nBaixando imagem do MySQL\n"
docker pull mysql

printf "\nInicializando o cluster Docker Swarm...\n"
docker swarm init

echo 'version: "3.0"' > docker-compose.yml
echo 'services:' >> docker-compose.yml
echo '  db:' >> docker-compose.yml
echo '    image: mysql' >> docker-compose.yml
echo '    deploy:' >> docker-compose.yml
echo "      replicas: $n_cont" >> docker-compose.yml
echo '    restart: always' >> docker-compose.yml
echo '    environment:' >> docker-compose.yml
echo "      MYSQL_ROOT_PASSWORD: $root_pass" >> docker-compose.yml
echo "      MYSQL_DATABASE: $db_name" >> docker-compose.yml
echo "      MYSQL_USER: $root_name" >> docker-compose.yml
echo "      MYSQL_PASSWORD: $db_pass" >> docker-compose.yml
echo '    ports:' >> docker-compose.yml
echo '      - "3306:3306"' >> docker-compose.yml
echo '    volumes:' >> docker-compose.yml
echo '      - ./data:/var/lib/mysql' >> docker-compose.yml

printf "\nCriando serviço do MySQL...\n"
docker stack deploy -c docker-compose.yml mysql

sleep 60

# Cria tabela no banco de dados
MYSQL_CONTAINER_ID=$(docker ps --filter "name=mysql_db." --format "{{.ID}}")
printf "\nO ID do primeiro contêiner é : $MYSQL_CONTAINER_ID\n"

## Inicia um shell dentro do container do MySQL
printf "\nAplicando o script SQL...\n"
docker cp /disk2/publica/project_iac3/advanced/modules/dbscript.sql $MYSQL_CONTAINER_ID:/dbscript.sql
docker exec -i $MYSQL_CONTAINER_ID sh -c "exec mysql -u root -p'$root_pass' $db_name < /dbscript.sql"