#!/bin/bash

# Remove all containers
docker rm -f $(docker ps -aq)

# Remove all services
docker service rm $(docker service ls -q)

# Remove all networks
docker network rm $(docker network ls -q)

# Remove all images
docker rmi -f $(docker images -aq)

# Remove the node from the Docker Swarm cluster
docker swarm leave --force
