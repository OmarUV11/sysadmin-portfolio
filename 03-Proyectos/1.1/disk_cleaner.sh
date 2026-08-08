#!/bin/bash

DISK_STATUS=$(df -h / | awk 'NR>1 {print $5}' | tr -d "%" | awk 'BEGIN { x = int($1); print x }')
UMBRAL=2
DATE=$(date "+%Y-%m-%d_%H-%m")


#Revision del estado de la particion 
if [ $DISK_STATUS -ge $UMBRAL ]; then 
	echo -e "\033[31m------------------------------------------\033[0m"
	echo -e "\033[31mALERTA USO DE LA PARTICION RAIZ ES CRITICO\033[0m"
	echo -e "\033[31m------------------------------------------\033[0m"	
	echo -e "\033[31m[ALERT] Ejecutando rutina de emergencia\033[0m"

elif [ $DISK_STATUS -le $UMBRAL ]; then
	{
	echo -e "\033[33m----------------------------------------------------------\033[0m"
	echo -e "\033[33m[INFO-$DATE] El uso de la particion raiz del servidor es estable\033[0m"
	echo -e "\033[33m----------------------------------------------------------\033[0m"
	} >> "LOG_SERVIDOR_PARTICION_.log"
	sleep 5
	exit 0 
fi

