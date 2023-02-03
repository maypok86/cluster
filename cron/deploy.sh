#!/bin/bash

set -e

readonly host=$1
readonly port=$2

ssh -o StrictHostKeyChecking=no deploy@"$host" -p "$port" 'rm -rf cron && mkdir cron'
scp -o StrictHostKeyChecking=no -P "$port" docker-compose-production.yml deploy@"$host":cron/docker-compose.yml
ssh -o StrictHostKeyChecking=no deploy@"$host" -p "$port" 'cd cron && docker stack deploy -c docker-compose.yml cron'
