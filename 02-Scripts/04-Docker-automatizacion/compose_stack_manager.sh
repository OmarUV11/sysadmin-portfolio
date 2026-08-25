#!/bin/bash 
# DESCRIPCIÓN: Gestiona el ciclo de vida de un stack multi-contenedor usando Docker Compose
#              según la acción indicada (up, down, status).
# USO:         ./compose_stack_manager.sh <ruta_directorio> <accion: up|down|status>
DOCKERCOMPOSE_DIR="$1"
DOCKER_ACTION="$2"


#VELIDACION DE DOS ARGUMENTOS OBLIGATORIOS#
if [ -z "$DOCKERCOMPOSE_DIR" ] || [[ -z "$DOCKER_ACTION" ]]; then 
	echo "ALGUNOS DE LOS DOS PARAMETROS NO SE PASO"
	echo "Uso: <up>|down|status>"
	exit 1
fi

#VERIFICAR QUE EXISTE EL DIRECTORIO#


if [ ! -d "$DOCKERCOMPOSE_DIR" ]; then
	echo "EL DIRECTORIO NO EXISTE"
	exit 1 
else 
	
	if [ -f "$DOCKERCOMPOSE_DIR/docker-compose.yml" ]; then 
		echo "EL ARCHIVO docker_compose.yml existe"
	else 
		echo "EL ARCHIVO NO EXISTE"
		exit 1
	fi
fi


cd "$DOCKERCOMPOSE_DIR" || exit 1
case "$DOCKER_ACTION" in

		up)
			docker compose up -d 
		;;


		down)
			read -p "¿TAMBIEN QUIERE ELIMINAR LOS VOLUMENES Y/n?" respuesta
			if [[ "$respuesta" =~ ^[Yy]$ ]]; then 
				docker compose down -v
			else
				docker compose down 
			fi
		;;

		status)
			docker compose ps 
		;;

		*)
			echo "OPCION NO VALIDA"
			exit 1
		;;

esac


echo "======================================"
echo "RESULTADO DEL STACK FINAL"
echo "======================================"
docker compose ps 
