#!/bin/bash

set -e

readonly host=$1
readonly port=$2

ssh -o StrictHostKeyChecking=no deploy@"$host" -p "$port" "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin $DOCKER_REGISTRY"

ssh -o StrictHostKeyChecking=no deploy@"$host" -p "$port" 'rm -rf redis && mkdir redis'

envsubst < docker-compose-production.yml > docker-compose-production-env.yml
scp -o StrictHostKeyChecking=no -P "$port" docker-compose-production-env.yml deploy@"$host":redis/docker-compose.yml
rm -f docker-compose-production-env.yml

ssh -o StrictHostKeyChecking=no deploy@"$host" -p "$port" 'cd redis && docker stack deploy -c docker-compose.yml redis'
