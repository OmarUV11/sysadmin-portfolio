#!/bin/bash
## DESCRIPCIÓN:  Monitorea una lista de servicios en un archivo y los reinicia si están caídos.	
DIR_STATIC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
FILE_NAME="$1"
FILE="$DIR_STATIC/$1"

if [ "$#" -eq 0 ]; then
	echo -e "\033[31m**********************************\033[0m"
	echo -e "\033[31mNo se paso ningun archivo de texto\033[0m" >&2
	echo -e "\033[31m**********************************\033[0m"
	sleep 3
	exit 1
fi

if [ ! -f "$FILE" ]; then
	echo -e "\033[31m************************************************\033[0m" >&2
	echo -e "\033[31mEl archivo que se paso como parametro  no existe\033[0m" >&2
	echo -e "\033[31m************************************************\033[0m" >&2
	exit 1
fi


while read -r servicio; do 
	if [ -z "$servicio" ] || [[ "$servicio" =~ ^# ]]; then
		continue
	fi

	if  systemctl is-active "$servicio" &>/dev/null ; then
		echo -e "\033[33m**********************************************************************\033[0m"
		echo -e "\033[33mEl servicio : [$servicio] ya esta activo y corriendo en el sistema\033[0m" >&2
		echo -e "\033[33m**********************************************************************\033[0m"
		sleep 4
	else
		echo -e "\033[31mEl servicio: [$servicio] no esta activo o no existe\033[0m"
		echo -e "\033[31mReinciando el servicio [$servicio]....\033[0m"
		sleep 4
		echo "Reiniciando servicio: [$servicio]"
		if ! systemctl restart "$servicio" &>/dev/null; then
			echo -e "\033[31m********************************************************************\033[0m"
			echo -e "\033[31mNo se logro reiniciar el servicio: [$servicio] ya que existe un error\033[0m"
			echo -e "\033[31m********************************************************************\033[0m"
		else
			sleep 3
			echo -e "\033[33m***********************************************\033[0m"
			echo -e "\033[33mSe reinicio el servicio: [$servicio] con exito\033[0m"
			echo -e "\033[33m***********************************************\033[0m"
		fi
		
		
	fi
	
done < "$FILE"
