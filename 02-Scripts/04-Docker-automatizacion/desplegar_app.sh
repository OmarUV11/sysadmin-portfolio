#!/bin/bash 
DOCKER_NAME="$1"
DOCKER_PORT="$2"
# DESCRIPCIÓN:  Despliega un contenedor Nginx mapeando un puerto del host.
set -euo pipefail

#Evaluar parametros#

if [ -z "$DOCKER_NAME" ] || [ -z "$DOCKER_PORT" ]; then 
	echo -e "\033[31m**********************************************\033[0m"
	echo -e "\033[31mAmbos o algun parametro falto por asignarce\033[0m"
	echo -e "\033[31m**********************************************\033[0m"
	exit 1
fi

#Validar si el contenedor existe
while read -r names; do 
	if [ "$names" == "$DOCKER_NAME" ]; then
		echo -e "\033[31m**********************************************\033[0m"
		echo -e "\033[31mEl contenedor: $DOCKER_NAME ya existe\033[0m" >&2
		echo -e "\033[31m**********************************************\033[0m"
		exit 1 
	fi
done < <(docker ps -a --format '{{.Names}}' 2>/dev/null)



#Desplegar el contenedor
if docker run -p "$DOCKER_PORT":80 --detach --name "$DOCKER_NAME" nginx &>/dev/null ; then 
	echo -e "\033[32m******************************************************************\033[0m"
	echo -e "\033[32mSe ha creado el docker: $DOCKER_NAME con el puerto $DOCKER_PORT\033[0m"
	echo -e "\033[32m******************************************************************\033[0m"
	exit 0
else
	echo -e "\033[31m*************************************************************************************************\033[0m"
	echo -e "\033[31m[ERROR] No se inicio del docker: $DOCKER_NAME ya que el puerto $DOCKER_PORT esta siendo utilizado"
	echo -e "\033[31m*************************************************************************************************\033[0m"
	exit 1
fi






