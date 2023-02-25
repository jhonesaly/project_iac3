#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get install docker.io -y -qq
apt-get install -y docker-compose -qq
apt-get install mysql-client-core-8.0 -y -qq
apt-get install -y python3 -qq
apt-get install -y python3-pip -qq
apt-get install nfs-server -y -qq
systemctl daemon-reexec
apt-get autoremove -y