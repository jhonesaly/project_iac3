#!/bin/bash

## 0 - Saudação

printf "\nIniciando protocolo new_iac_3...\n"
printf "\nEm caso de dúvida, consulte a documentação disponível em <https://github.com/jhonesaly/project_iac3>\n"

question_number=1

while true; do

    ## 1 - Configurações

    if [ $question_number -eq 1 ]; then
        read -n 1 -p "Deseja criar um banco de dados via contêiner? [y/n] " ans_a1
        printf "\n...\n"
        
        if [ "$ans_a1" != "y" ] && [ "$ans_a1" != "n" ]; then
            printf "\nDigite um comando válido.\n"
            continue

        else
            read -n 1 -p "Deseja usar respostas 'default' para realizar tester? [y/n] " ans_at
            printf "\n...\n"
            if [ "$ans_at" = "y" ]; then
                db_name='test1'
                root_name='root'
                root_pass='123'
                n_cont='2'
                ans_a2='n'
                n_rand_data='1'
                ans_a3='n'
                ans_a4='n'

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
                    read -n 1 -p "Deseja criar um proxy? [y/n] " ans_a4
                    printf "\n...\n"
                fi
            fi

            question_number=2
            continue
        fi
    fi
    
    printf "\nConfigurando...\n"
    break
done

ip_lead=$(ip addr show | grep -E "inet .*brd" | awk '{print $2}' | cut -d '/' -f1 | head -n1)


# Embalando variáveis de ambiente para usar nos módulos

export ans_a1=$ans_a1
export ans_a2=$ans_a2
export ans_a3=$ans_a3

export ip_lead=$ip_lead
export db_name=$db_name
export root_name=$root_name
export root_pass=$root_pass
export n_cont=$n_cont

export n_rand_data=$n_rand_data

##  - Cria banco de dados

./modules/need_install.sh

if [ $ans_a1 = "y" ]; then
    printf "\nIniciando módulo docker...\n"   
    ./modules/docker_leader.sh "$db_name" "$root_name" "$root_pass" "$n_cont"
    
    if [ $ans_a2 = "y" ]; then
        ## - Insere produtos aleatórios no banco de dados
        printf "\nInserindo produtos aleatórios...\n"
        python3 ./modules/rand_insert.py "$ip_lead" "$db_name" "$root_pass" "$n_rand_data"
    fi    

    if [ $ans_a3 = "y" ]; then

        ## - Cria o cluster
        token=$(docker swarm init --quiet)
        export token=$token
        echo "/disk2/publica/project_iac3/advanced *(rw,sync,subtree_check)" | sudo tee -a /etc/exports
        exportfs -ar

    fi  
    
    if [ $ans_a4 = "y" ]; then

        ## - Cria o proxy
        mkdir proxy
        cp /modules/nginx.conf /proxy
        cp /modules/dockerfile /proxy
        cd proxy
        docker build -t proxy-app .
        docker run --name my-proxy-app -dti -p 4500:4500 proxy-app
        cd ..
    fi  
fi

## - Fim
printf "\nFinalizado.\n"