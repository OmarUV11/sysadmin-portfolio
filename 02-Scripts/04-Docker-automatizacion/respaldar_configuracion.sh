#!/bin/bash 
#crea un script llamado respaldar_config.sh en 04-docker-automation/ que reciba el nombre o ID de un contenedor ($1) para exportar su configuración en formato JSON:
NOMBRE_O_ID="$1"
CARPETA="backups"
if [ "$#" -ne 1 ];then 
	echo -e "\033[31m******************************************************\033[0m"
	echo -e "\033[31mNo se paso ningun nombre o id de docker como parametro\033[0m" >&2
	echo -e "\033[31m******************************************************\033[0m"

	echo -e "\033[31m---Estos son los nombres de los contenedores disponibles---\033[0m"
	docker ps --format '{{.Names}}'
	sleep 5
	exit 1
fi

if ! docker inspect "$NOMBRE_O_ID" &>/dev/null; then 
	echo -e "\033[31m****************************************************\033[0m"
	echo -e "\033[31mEl docker con el nombre o id: $NOMBRE_O_ID no existe\033[0m"
	echo -e "\033[31m****************************************************\033[0m"
	exit 1		
fi


if [ ! -d "$CARPETA" ]; then 
        echo -e "\033[31m********************************\033[0m" 
        echo -e "\033[31mEL directorio $CARPETA no existe\033[0m"
        echo -e "\033[31m********************************\033[0m"
	sleep 2
	
	echo -e "\033[33m*********************************\033[0m"
	echo -e "\033[33mCreando el directorio $CARPETA\033[0m"
	echo -e "\033[33m*********************************\033[0m"
	mkdir -p "$CARPETA"
	sleep 2

	echo -e "\033[32m******************************\033[0m"
	echo -e "\033[32mSe creo el directorio $CARPETA\033[0m"
	echo -e "\033[32m******************************\033[0m"
fi

docker inspect "$NOMBRE_O_ID" > "$CARPETA/${NOMBRE_O_ID}_$(date +%Y-%m-%d).json"



