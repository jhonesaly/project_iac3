#!/bin/bash

## 0 - Saudação

printf "\nIniciando protocolo new_iac_3...\n"
printf "\nEm caso de dúvida, consulte a documentação disponível em <https://github.com/jhonesaly/project_iac3>\n"

question_number=1

while true; do

    ## 1 - Configurações

    if [ $question_number -eq 1 ]; then
        read -n 1 -p "Deseja criar contêiner de banco de dados? [y/n] " ans_a1
        printf "\n...\n"
        
        if [ "$ans_a1" != "y" ] && [ "$ans_a1" != "n" ]; then
            printf "\nDigite um comando válido.\n"
            continue

        else
            if [ "$ans_a1" = "y" ]; then
                read -p "Digite o nome do banco de dados: " db_name
                printf "\n...\n"
                read -p "Digite o nome do administrador do banco de dados: " root_name
                printf "\n...\n"
                read -p "Digite a senha do administrador do banco de dados: " root_pass
                printf "\n...\n"
                read -p "Deseja criar quantas réplicas do contêiner? " n_cont
                printf "\n...\n"
                read -n 1 -p "Deseja criar produtos aleatórios no banco para testes? [y/n] " ans_a2
                printf "\n...\n"
                    if [ $ans_a2 = "y" ]; then
                    read -p "Deseja inserir quantos produtos aleatórios? " n_rand_data
                    printf "\n...\n"
                    fi
                read -n 1 -p "Deseja criar um cluster? [y/n] " ans_a3
                printf "\n...\n"
                    if [ $ans_a3 = "y" ]; then
                    read -p "Deseja adicionar quantos nós ao cluster? " n_nodes
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


# Embalando variáveis de ambiente para usar nos módulos

export ans_a1=$ans_a1
export ans_a2=$ans_a2
export ans_a3=$ans_a3

export db_name=$db_name
export root_name=$root_name
export root_pass=$root_pass
export n_cont = $n_cont

export n_rand_data=$n_rand_data

export n_nodes=$n_nodes

##  - Cria banco de dados

./modules/need_install.sh

if [ $ans_a1 = "y" ]; then
    printf "\nCriando primeiro container...\n"
    
    ./modules/docker_leader.sh
    
    if [ $ans_a2 = "y" ]; then
        
        ## - Insere produtos aleatórios no banco de dados
        printf "\nInserindo produtos aleatórios...\n"
        for i in $(seq 1 $n_rand_data);
        do
            python3 ./modules/rand_insert.py
        done
    fi    

    if [ $ans_a3 = "y" ]; then

        ## - Cria o cluster
        
    fi  
fi

## - Fim
printf "\nFinalizado.\n"