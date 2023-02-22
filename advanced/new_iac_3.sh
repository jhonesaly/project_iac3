#!/bin/bash

## 0 - Saudação

printf "\nIniciando protocolo new_iac_3...\n"
printf "\nEm caso de dúvida, consulte a documentação disponível em <https://github.com/jhonesaly/project_iac3>\n"

question_number=1

while true; do

    ## 1 - Configurações

    if [ $question_number -eq 1 ]; then
        read -n 1 -p "Deseja criar banco de dados? [y/n] " ans_a1
        printf "\n...\n"
        
        if [ "$ans_a1" != "y" ] && [ "$ans_a1" != "n" ]; then
            printf "\nDigite um comando válido.\n"
            continue

        else
            if [ "$ans_a1" = "y" ]; then
                read -n 1 -p "Deseja criar via docker? [y/n] " ans_db1
                printf "\n...\n"
                read -p "Digite o nome do banco de dados: " db_name
                printf "\n...\n"
                read -p "Digite o nome do administrador do banco de dados: " root_name
                printf "\n...\n"
                read -p "Digite a senha do administrador do banco de dados: " root_pass
                printf "\n...\n"
                read -n 1 -p "Deseja criar produtos aleatórios no banco para testes? [y/n] " ans_db2
                printf "\n...\n"
                    if [ $ans_db2 = "y" ]; then
                    read -p "Deseja inserir quantos produtos aleatórios? " n_inserts
                    printf "\n...\n"
            fi
            
            question_number=2
            continue
        fi
    fi
    
    printf "\nConfigurando...\n"
    break
done

ip_vm=$(ip addr show | grep -E "inet .*brd" | awk '{print $2}' | cut -d '/' -f1 | head -n1)

##  - Cria banco de dados
if [ $ans_a1 = "y" ]; then
    printf "\nIniciando módulo de criação de banco de dados...\n"
    if [ $ans_db1 = "y" ]; then
        ./modules/new_mysql_docker.sh "$db_name" "$root_name" "$root_pass"
        if [ $ans_db2 = "y" ]; then
            pip install random barcode pymysql
            for i in $(seq 1 $and_db6);
            do
                python ./modules/rand_insert.py "$ip_vm" "$db_name" "$root_pass"
            done
        fi
    else
        ./modules/new_mysql.sh "$db_name" "$root_name" "$root_pass"
    fi
fi

## - Insere produtos aleatórios no banco de dados


## - Fim
printf "\nFinalizado.\n"