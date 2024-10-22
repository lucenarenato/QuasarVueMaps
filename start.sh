#!/bin/bash

# Autor: Renato Lucena <cpdrenato@gmail.com> #
# * Inciar docker
# #
################################################

echo "Starting dockerfiles via docker-compose"
NOW_DATE=$(date "+%Y%m%d-%T")
NOW="$NOW_DATE"

echo "==================================== Start $NOW  ===================================="

docker-compose -f frontend/docker-compose.dev.yml up -d --build --force-recreate --no-dep

cd backend/
cp .env.example .env
composer install -o
./vendor/bin/sail up -d

echo "aguarde o fim do processo"
RED='\033[0;31m'
NC='\033[0m' # No Color
printf "Obs: ${RED}Aguarde o fim do processo${NC} !\n"
sleep 0m 35s

sudo chmod -R 777 storage/ bootstrap/
./vendor/bin/sail artisan migrate --seed
# ./vendor/bin/sail artisan passport:install
./vendor/bin/sail artisan key:generate
./vendor/bin/sail artisan config:cache
# docker-compose -f back-end/docker-compose.yml up -d
docker ps

echo "===> All services iniciados"
echo "====================================  End $NOW   ===================================="
echo "Rotina terminou em: $(date +%Y-%m-%d_%H:%M:%S)"
