#!/bin/bash

## 0 - Saudação

    GREEN='\033[0;32m'
    NC='\033[0m'

    printf "\n${GREEN}Iniciando protocolo new_iac_3...${NC}\n"
    printf "\n${GREEN}Em caso de dúvida, consulte a documentação disponível em <https://github.com/jhonesaly/project_iac3>${NC}\n\n"

## 1 - Adicionando configurações

    question_number=1

    while true; do

        if [ $question_number -eq 1 ]; then
            read -n 1 -p "Deseja criar um leader no cluster? [y/n] " ans_a1
            printf "\n...\n"
                    
            if [ "$ans_a1" = "y" ]; then
                read -n 1 -p "Deseja usar o arquivo master_vars.conf configurado manualmente? [y/n] " ans_at
                printf "\n...\n"

                if [ "$ans_at" = "y" ]; then
                    question_number=2
                    continue
                
                elif [ "$ans_at" = "n" ]; then
                    read -p "Digite o nome do banco de dados: " db_name
                    printf "\n...\n"
                    read -p "Digite a senha do administrador do banco de dados: " root_pass
                    printf "\n...\n"
                    read -p "Digite o nome do administrador do banco de dados: " root_name
                    printf "\n...\n"
                    read -p "Deseja criar quantos contêineres para o serviço? " n_cont
                    printf "\n...\n"
                    read -n 1 -p "Deseja criar produtos aleatórios no banco para testes? [y/n] " ans_a2
                    printf "\n...\n"
                        if [ $ans_a2 = "y" ]; then
                        read -p "Deseja inserir quantos produtos aleatórios? " n_rand_data
                        printf "\n...\n"
                        fi
                    
                    master_ip=$(hostname -I | awk '{print $1}')

                    echo "ans_a1=${ans_a1}" > master_vars.conf
                    echo "ans_a2=${ans_a1}" >> master_vars.conf
                    echo "db_name=${db_name}" >> master_vars.conf
                    echo "root_name=${root_name}" >> master_vars.conf
                    echo "root_pass=${root_pass}" >> master_vars.conf
                    echo "n_cont=${n_cont}" >> master_vars.conf
                    echo "n_rand_data=${n_rand_data}" >> master_vars.conf
                    echo "master_ip=${master_ip}" >> master_vars.conf

                    question_number=2
                    continue

                else
                    printf "\n${GREEN}Digite um comando válido.${NC}\n"
                    continue
                fi
                question_number=2
                continue

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
            read -n 1 -p "Deseja criar um worker no cluster? [y/n] " ans_b1
            printf "\n...\n"
            
            if [ "$ans_b1" = "y" ] || [ "$ans_b1" = "n" ]; then
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

    if [ "$ans_a1" = "y" ]; then
        
        printf "\n${GREEN}Iniciando criação do leader...${NC}\n"   
        ./modules/create_leader.sh
        
        if [ "$ans_a2" = "y" ]; then
            printf "\n${GREEN}Inserindo produtos aleatórios via shell...${NC}\n"
                pip3 install pymysql
                source master_vars.conf
                python3 ./modules/app/rand_insert_shell.py "$master_ip" "$db_name" "$root_pass" "$n_rand_data"
            
            printf "\n${GREEN}Inserindo produtos aleatórios via proxy...${NC}\n"
                curl http://localhost:4500/rand_insert_proxy.py
        fi    
    
    fi

    if [ "$ans_b1" = "y" ]; then
        printf "\n${GREEN}Iniciando criação do worker...${NC}\n"
        ./modules/create_worker.sh
    fi

## 3 - Fim

    printf "\n${GREEN}Finalizado.${NC}\n"