#!/bin/bash 
# DESCRIPCIÓN: Valida e instala localmente una imagen de Docker si no existe,
#              y despliega un contenedor asignándole un nombre dinámico
#              con mapeo de puertos al Host.
# USO:         ./docker_runner.sh <nombre_imagen> [puerto_host]
NOMBRE_IMG="$1"
DATE=$(date '+%Y_%m_%d')
echo "$NOMBRE_IMG"

#VERIFICACION DEL PARAMETRO DE NOMBRE#
if [ -z "$NOMBRE_IMG" ]; then 
	echo "NO SE PASO EL NOMBRE DE LA IMAGEN"
	exit 1 
fi

#VERIFICAR SI LA IMAGEN EXISTE LOCALMENTE#

if ! docker image inspect "$NOMBRE_IMG" &>/dev/null; then 
	echo "NO EXISTE EL IMAGEN LOCALMENTE"
	echo "Descargando imagen del docker espere ....."
	sleep 4

	if ! docker pull "$NOMBRE_IMG" &>/dev/null ; then 
		echo "NOMBRE DE IMAGEN  NO VALIDA"
		exit 1 
	fi

	echo "Descarga finalizada"

else
	echo "========================================"
	echo "LA IMAGEN EXISTE LOCALMENTE"
	echo "========================================"
	
	
fi

NOMBRE_CLEAR=$(echo "$NOMBRE_IMG" | tr '/:' '_')
CONTENEDOR_NOMBRE="${NOMBRE_CLEAR}_${DATE}" 


docker run -d --name  "$CONTENEDOR_NOMBRE" -p 8080:80  "$NOMBRE_IMG" 
echo "======================================"
echo "SE INICIO EL DOCKER $CONTENEDOR_NOMBRE"
echo "======================================"

docker inspect "$CONTENEDOR_NOMBRE" --format 'ID_DOCKER:{{.Id}} ESTATUS_DOCKER:{{.State.Status}}'
