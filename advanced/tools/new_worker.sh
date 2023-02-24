#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get install docker.io -y -qq
apt-get install nfs-commons

mount -o v3 $ip_leader:/disk2/publica/project_iac3/advanced