#!/bin/bash

db_name="$1" 
root_name="$2" 
root_pass="$3"
n_cont="$4"

printf "\nBaixando imagem do MySQL\n"
docker pull mysql

# Criar arquivo docker-compose.yml
echo 'version: "3.9"' > docker-compose.yml
echo 'services:' >> docker-compose.yml
echo '  db:' >> docker-compose.yml
echo '    image: mysql' >> docker-compose.yml
echo '    restart: always' >> docker-compose.yml
echo '    environment:' >> docker-compose.yml
echo "      MYSQL_ROOT_PASSWORD: ${root_pass}" >> docker-compose.yml
echo "      MYSQL_DATABASE: ${db_name}" >> docker-compose.yml
echo "      MYSQL_USER: ${root_name}" >> docker-compose.yml
echo "      MYSQL_PASSWORD: ${root_pass}" >> docker-compose.yml
echo '    ports:' >> docker-compose.yml

# Adicionar portas dinâmicas
for (( i=1; i<=$n_cont; i++ ))
do
  echo "      - '${((i-1)*3306+3306)}:3306'" >> docker-compose.yml
done

echo '    volumes:' >> docker-compose.yml
echo '      - ./data:/var/lib/mysql' >> docker-compose.yml
echo '    deploy:' >> docker-compose.yml
echo "      replicas: ${n_cont}" >> docker-compose.yml
echo '      placement:' >> docker-compose.yml
echo '        constraints:' >> docker-compose.yml
echo '          - node.role == worker' >> docker-compose.yml


printf "\nMontando o contêiner MySQL...\n"
docker-compose up -d
sleep 30

# Cria tabela no banco de dados

MYSQL_CONTAINER_ID=$(docker ps --filter "name=advanced_db_1" --format "{{.ID}}")
printf "\nO ID do primeiro contêiner é : $MYSQL_CONTAINER_ID\n"

## Inicia um shell dentro do container do MySQL
printf "\nAplicando o script SQL...\n"
docker cp /disk2/publica/project_iac3/advanced/modules/dbscript.sql $MYSQL_CONTAINER_ID:/dbscript.sql
docker exec -i $MYSQL_CONTAINER_ID sh -c "exec mysql -u root -p'$root_pass' $db_name < /dbscript.sql"
