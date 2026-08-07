#!/bin/bash 
#Crea un script llamado verificar_puertos.sh que reciba un argumento: el nombre o ID de un contenedor ($1).
ID_NOMBRE="$1"
if [ "$#" -ne 1 ];then
	echo -e "\033[31m***************************\033[0m"
	echo -e "\033[31m[ALERT]No se paso ningun parametro\033[0m">&2
	echo -e "\033[31m***************************\033[0m"
	exit 1
fi

STATUS_DOCKER=$(docker inspect "$ID_NOMBRE" --format '{{.State.Running}}' 2>/dev/null)
if [ "$STATUS_DOCKER" != "true" ]  ; then
	echo -e "\033[31m*********************************************************************\033[0m"
	echo -e "\033[31m[ALERT] El docker con el ID o Nombre: $ID_NOMBRE no existe o esta denetenido\033[0m" >&2
	echo -e "\033[31m*********************************************************************\033[0m"
	exit 1
else 
	PORTS=$(docker port "$ID_NOMBRE")
	echo -e "\033[32m----------------------------------------------------\033[0m"
	echo -e "\033[32mEL docker con el ID o Nombre: $ID_NOMBRE esta activo\033[0m"
	echo -e "\033[32m----------------------------------------------------\033[0m"
	if  [ -z "$PORTS" ];then
		echo -e "\033[33m---------------------------------------------------\033[0m"
                echo -e "\033[33m[INFO] El contenedor: $ID_NOMBRE solo opera en red interna\033[0m"
		echo -e "\033[33m---------------------------------------------------\033[0m"
		exit 0
        fi

	echo -e "\033[32mPuertos abiertos del docker: $ID_NOMBRE:\033[0m"
	echo -e "\033[32m----------------------------------------------------\033[0m"
	echo -e "\033[32m$PORTS\033[0m"

fi



