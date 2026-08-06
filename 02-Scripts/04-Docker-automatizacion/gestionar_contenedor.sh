#!/bin/bash 
# DESCRIPCIÓN:  Verifica el estado de un contenedor Docker e intenta iniciarlo
#               si se encuentra en estado detenido.
ID_NOMBRE_DOCKER="$1"
if [ "$#" -eq 0 ]; then 
	echo "\033[31mNo se paso ningun valor como argumento\033[0m" >&2
	exit 1
fi

#Verificar el estado del deamon de docker y si esta instalado#
if ! command -v docker &>/dev/null; then 
	echo -e "\033[31mDocker no se encuentra instalado\033[0m" >&2
	exit 1
fi

if ! systemctl is-active docker &>/dev/null; then 
	echo -e "\033[31mDocker esta instalado pero esta desactivado\033[0m" >&2
	exit 1 
fi 
	
#Inspeccionar el estado del docker 
STATUS_DOCKER=$(docker inspect "$ID_NOMBRE_DOCKER" --format '{{.State.Running}}' 2>/dev/null)

#Verificacion del estado del docker 
if [ "$STATUS_DOCKER" == "true" ]; then
	echo -e "\033[32m*************************************************************************\033[0m"
	echo -e "\033[32mEL contenedor con el Nombre o ID: '{$ID_NOMBRE_DOCKER}' esta corriendo\033[0m"	
	echo -e "\033[32m*************************************************************************\033[0m"
elif [ "$STATUS_DOCKER" == "false" ]; then 
	echo -e "\033[33m**************************************************************************\033[0m"
	echo -e "\033[33mEl contenedor con el Nombre o ID: '{$ID_NOMBRE_DOCKER}' esta denenido \033[0m"
	echo -e "\033[33m**************************************************************************\033[0m"
	echo -e "\033[33mInciando el docker...\033[0m"
 	docker start "$ID_NOMBRE_DOCKER" &>/dev/null
	sleep 5
else 
	echo -e "\033[31m***************************************************************************\033[0m"
	echo -e "\033[31mNo existe el docker con el ID o NOMBRE: $ID_NOMBRE_DOCKER\033[0m"
	echo -e "\033[31m***************************************************************************\033[0m"
	exit 1
fi

