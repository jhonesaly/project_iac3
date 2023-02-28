#!/bin/bash

GREEN='\033[0;32m'
NC='\033[0m'

## 0 - Saudação

    printf "\n${GREEN}Iniciando protocolo new_iac_3...${NC}\n"
    printf "\n${GREEN}Em caso de dúvida, consulte a documentação disponível em <https://github.com/jhonesaly/project_iac3>${NC}\n\n"

## 1 - Adicionando configurações

    question_number=1

    while true; do

        if [ $question_number -eq 1 ]; then
            read -n 1 -p "Deseja criar um banco de dados mysql master? [y/n] " ans_a1
            printf "\n...\n"
                    
            if [ "$ans_a1" = "y" ]; then
                read -n 1 -p "Deseja usar respostas 'default' para realizar testes? [y/n] " ans_at
                printf "\n...\n"
                if [ "$ans_at" = "y" ]; then
                    db_name='testdb'
                    root_pass='123'
                    root_name='tester'
                    n_cont='2'
                    ans_a2='y'
                    n_rand_data='1'

                    question_number=2
                    continue
                
                elif [ "$ans_at" = "n" ]; then
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

                    question_number=2
                    continue

                else
                    printf "\n${GREEN}Digite um comando válido.${NC}\n"
                    continue
                fi
            
            elif [ "$ans_a1" = "n" ]; then
                question_number=2
                continue

            else
                printf "\n${GREEN}Digite um comando válido.${NC}\n"
                continue
            fi

        printf "\n${GREEN}Configurando...${NC}\n"
        fi
        
        if [ $question_number -eq 2 ] && [ "$ans_a1" = "n" ]; then
            read -n 1 -p "Deseja criar um banco de dados mysql worker? [y/n] " ans_b1
            printf "\n...\n"
            
            if [ "$ans_b1" = "y" ]; then
                read -p "Deseja criar quantos contêineres na máquina? " n_cont
                printf "\n...\n"
                
                question_number=3
                continue

            elif [ "$ans_b1" = "n" ]; then
                question_number=3
                continue

            else
                printf "\n${GREEN}Digite um comando válido.${NC}\n"
                continue
            fi

        printf "\n${GREEN}Configurando...${NC}\n"
        fi

        break
    done

## 2 - Executando módulos



    if [ "$ans_a1" = "y" ]; then ## - Cria mysql master

        printf "\n${GREEN}Iniciando criação do mysql master...${NC}\n"   
        ./modules/create_master.sh "$db_name" "$root_name" "$root_pass" 

        if [ "$ans_a2" = "y" ]; then ## - Insere produtos aleatórios no banco de dados
            printf "\n${GREEN}Inserindo produtos aleatórios...${NC}\n"
            pip3 install pymysql
            master_ip=$(hostname -I | awk '{print $1}')
            python3 ./modules/rand_insert.py "$master_ip" "$db_name" "$root_pass" "$n_rand_data"
        fi    
    
    fi

    if [ "$ans_b1" = "y" ]; then ## - Cria mysql worker
        printf "\n${GREEN}Iniciando criação do mysql worker...${NC}\n"
        ./modules/create_worker.sh "$db_name" "$root_name" "$root_pass" "$n_cont"
    fi

## 3 - Fim

    printf "\n${GREEN}Finalizado.${NC}\n"