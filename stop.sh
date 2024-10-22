#!/bin/bash

# Autor: Renato Lucena <cpdrenato@gmail.com> #
# * Inciar docker
# #
################################################

echo "STOP"
NOW_DATE=$(date "+%Y%m%d-%T")
NOW="$NOW_DATE"

echo "==================================== Start $NOW  ===================================="
echo "aguarde o fim do processo"
RED='\033[0;31m'
NC='\033[0m' # No Color
printf "Obs: ${RED}Aguarde o fim do processo${NC} !\n"

docker-compose -f front-end/docker-compose.yml down -v
cd backend/
./vendor/bin/sail down -v

# docker-compose -f back-end/docker-compose.yml up -d

echo "===> All services parados"
echo "====================================  End $NOW   ===================================="
echo "Rotina terminou em: $(date +%Y-%m-%d_%H:%M:%S)"
