#!/bin/bash

set -e

readonly host=$1
readonly port=$2

ssh -o StrictHostKeyChecking=no deploy@"$host" -p "$port" 'mkdir -p configs'
scp -r -o StrictHostKeyChecking=no -P "$port" alertmanager deploy@"$host":configs/alertmanager
scp -r -o StrictHostKeyChecking=no -P "$port" prometheus deploy@"$host":configs/prometheus
ssh -o StrictHostKeyChecking=no deploy@"$host" -p "$port" 'docker network create --driver=overlay traefik-public || true'
ssh -o StrictHostKeyChecking=no deploy@"$host" -p "$port" 'docker network create --driver=overlay monitoring-public || true'
ssh -o StrictHostKeyChecking=no deploy@"$host" -p "$port" 'rm -rf monitoring && mkdir monitoring'
scp -o StrictHostKeyChecking=no -P "$port" docker-compose-production.yml deploy@"$host":monitoring/docker-compose.yml
ssh -o StrictHostKeyChecking=no deploy@"$host" -p "$port" 'cd monitoring && docker stack deploy -c docker-compose.yml monitoring'
