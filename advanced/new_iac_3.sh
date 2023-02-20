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
                read -p "Digite o nome do banco de dados: " ans_db2
                printf "\n...\n"
                read -p "Digite o nome do administrador do banco de dados: " ans_db3
                printf "\n...\n"
                read -p "Digite a senha do administrador do banco de dados: " ans_db4
                printf "\n...\n"
            fi
            
            question_number=2
            continue
        fi
    fi
    
    printf "\nConfigurando...\n"
    break
done

##  - Cria banco de dados

if [ $ans_a1 = "y" ]; then
    printf "\nIniciando módulo de criação de banco de dados...\n"
    if [ $ans_db1 = "y" ]; then
        ./modules/new_mysql_docker.sh "$ans_db1" "$ans_db2" "$ans_db3" "$ans_db4"
    else
        ./modules/new_mysql.sh "$ans_db1" "$ans_db2" "$ans_db3" "$ans_db4"
    fi
fi

## - Fim
printf "\nFinalizado.\n"