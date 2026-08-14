#!/bin/bash 
# ==============================================================================
# SCRIPT:       limpiar_contenedores.sh
# UBICACIÓN:    04-Docker-automatizacion/
# DESCRIPCIÓN:  Identifica y elimina contenedores en estado inactivo/detenido.
# USO:          ./limpiar_contenedores.sh
# ==============================================================================
DOCKER_EXITED=$(docker ps -a -f status=exited -f status=created --format '{{.Names}}')
if [ -z "$DOCKER_EXITED" ]; then
	echo -e "\033[33m********************************************\033[0m"
	echo -e "\033[33m[INFO]-No existen dockers en estado inactivo\033[0m"
	echo -e "\033[33m********************************************\033[0m"
	exit 0
else 
	echo "***Lista dockers inactivos***"
	echo "$DOCKER_EXITED"
	sleep 5
	
fi

echo "******************************************************"
echo "Se procedera con la eliminacion segura de los dockers "
echo "******************************************************"
sleep 3

while read -r nombre; do 
	echo "Eliminando docker: $nombre"
	docker rm "$nombre" &>/dev/null; 
	echo "[OK] Se elimino el docker: $nombre"
	sleep 1
done <<< "$DOCKER_EXITED"

echo -e "\033[32m*********************\033[0m"
echo -e "\033[32mELminacion completada\033[0m"
echo -e "\033[32m*********************\033[0m"
sleep 3
