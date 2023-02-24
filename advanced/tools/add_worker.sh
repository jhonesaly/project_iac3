#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get install docker.io -y -qq
apt-get install nfs-commons

mount -o v3 $ip_leader:/disk2/publica/project_iac3/advanced



# Endereço IP da nova máquina worker
new_worker_ip=$(ip addr show | grep -E "inet .*brd" | awk '{print $2}' | cut -d '/' -f1 | head -n1)

# Arquivo de configuração do Nginx
nginx_conf="/etc/nginx/nginx.conf"

# Adiciona o endereço IP da nova máquina worker à seção "upstream all" do arquivo de configuração do Nginx
sudo sed -i "/upstream all {/a \ \ \ \ server $new_worker_ip:80;" $nginx_conf

# Recarrega a configuração do Nginx
sudo systemctl reload nginx
