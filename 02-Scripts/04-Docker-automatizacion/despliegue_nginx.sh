#!/bin/bash 
# ==============================================================================
# SCRIPT:       desplegar_nginx.sh
# UBICACIÓN:    04-Docker-automatizacion/
# DESCRIPCIÓN:  Despliega Nginx con auto-limpieza en caso de conflicto de puertos.
# USO:          ./desplegar_nginx.sh <nombre_contenedor> <puerto_host>
# ==============================================================================

NOMBRE_DOCKER="$1"
PUERTO_DOCKER="$2"
IMG_DOCKER_NGINX="nginx:alpine"

if [ -z "$NOMBRE_DOCKER" ] || [ -z "$PUERTO_DOCKER" ]; then 
	echo -e "\033[31m---------------------------------------------\033[0m"
	echo -e "\033[31m[ERROR] Uno o los  dos parametros no fueron pasados \033[0m" >&2
	echo -e "\033[31m---------------------------------------------\033[0m"
	exit 1 
fi

while read -r dockers; do 
	if [ "$dockers" == "$NOMBRE_DOCKER" ]; then	
		echo -e "\033[31m------------------------------------------\033[0m"
		echo -e "\033[31m[ERROR] El nombre: $NOMBRE_DOCKER ya existe\033[0m"
		echo -e "\033[31m------------------------------------------\033[0m" 
		exit 1 
	fi
done < <(docker ps -a --format '{{.Names}}')

if ! docker run -d --name "$NOMBRE_DOCKER" -p "$PUERTO_DOCKER":80 "$IMG_DOCKER_NGINX" &>/dev/null; then 
	echo -e  "\033[33m[Error]EL puerto : $PUERTO_DOCKER esta siendo utilizado por otro Docker" >&2
	docker rm "$NOMBRE_DOCKER" &>/dev/null
	exit 1
else 
	echo -e "\033[32m[EXITO]Se creado el docker NGINX con el nombre $NOMBRE_DOCKER\033[0m"	
fi 


