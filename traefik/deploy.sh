#!/bin/bash

set -e

readonly host=$1
readonly port=$2

ssh -o StrictHostKeyChecking=no deploy@"$host" -p "$port" 'docker network create --driver=overlay traefik-public || true'
ssh -o StrictHostKeyChecking=no deploy@"$host" -p "$port" 'rm -rf traefik && mkdir traefik'
scp -o StrictHostKeyChecking=no -P "$port" docker-compose-production.yml deploy@"$host":traefik/docker-compose.yml
ssh -o StrictHostKeyChecking=no deploy@"$host" -p "$port" 'cd traefik && docker stack deploy -c docker-compose.yml traefik'