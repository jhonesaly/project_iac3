#!/bin/bash

## 0 - Saudação

printf "\nIniciando protocolo new_iac_3...\n"
printf "\nEm caso de dúvida, consulte a documentação disponível em <https://github.com/jhonesaly/project_iac3>\n"

question_number=1

while true; do

    ## 1 - Configurações

    if [ $question_number -eq 1 ]; then
        read -n 1 -p "Deseja criar um banco de dados mysql master? [y/n] " ans_a1
        printf "\n...\n"
        
        if [ "$ans_a1" != "y" ] && [ "$ans_a1" != "n" ]; then
            printf "\nDigite um comando válido.\n"
            continue

        else
            read -n 1 -p "Deseja usar respostas 'default' para realizar testes? [y/n] " ans_at
            printf "\n...\n"
            if [ "$ans_at" = "y" ]; then
                db_name='testdb'
                root_pass='123'
                root_name='tester'
                n_cont='2'
                ans_a2='y'
                n_rand_data='1'
                ans_a3='n'
                ans_a4='n'

            else
                if [ "$ans_a1" = "y" ]; then
                    read -p "Digite o nome do banco de dados: " db_name
                    printf "\n...\n"
                    read -p "Digite a senha do administrador do banco de dados: " root_pass
                    printf "\n...\n"
                    read -p "Digite o nome do administrador do banco de dados: " root_name
                    printf "\n...\n"
                    read -n 1 -p "Deseja criar produtos aleatórios no banco para testes? [y/n] " ans_a2
                    printf "\n...\n"
                        if [ $ans_a2 = "y" ]; then
                        read -p "Deseja inserir quantos produtos aleatórios? " n_rand_data
                        printf "\n...\n"
                        fi
                fi
            fi

            question_number=2
            continue
        fi

    printf "\nConfigurando...\n"
    fi

    
    
    if [ $question_number -eq 2 ]; then
        read -n 1 -p "Deseja criar um banco de dados mysql worker? [y/n] " ans_b1
        printf "\n...\n"
        
        if [ "$ans_b1" != "y" ] && [ "$ans_b1" != "n" ]; then
            printf "\nDigite um comando válido.\n"
            continue
        
        else
            read -p "Deseja criar quantos contêineres na máquina? " n_cont
            printf "\n...\n"

            question_number=3
            continue
        fi

    printf "\nConfigurando...\n"
    fi

    break
done

##  - Cria banco de dados

if [ $ans_a1 = "y" ]; then ## - Cria mysql master

    printf "\nIniciando módulo create_master...\n"   
    ./modules/create_master.sh "$db_name" "$root_name" "$root_pass" 
    docker swarm join-token worker | tail -n +2 > worker_token.sh
    ip_master=$(ip addr show | grep -E "inet .*brd" | awk '{print $2}' | cut -d '/' -f1 | head -n1) 
    ip_master> master_ip.sh
    
    if [ $ans_a2 = "y" ]; then ## - Insere produtos aleatórios no banco de dados
        printf "\nInserindo produtos aleatórios...\n"
        pip3 install pymysql
        python3 ./modules/rand_insert.py "$ip_master" "$db_name" "$root_pass" "$n_rand_data"
    fi    
   
fi

if [ $ans_b1 = "y" ]; then ## - Cria mysql worker
    printf "\nIniciando módulo create_worker...\n"
    ./modules/create_worker.sh "$db_name" "$root_name" "$root_pass" "$n_cont"
fi

## - Fim
printf "\nFinalizado.\n"