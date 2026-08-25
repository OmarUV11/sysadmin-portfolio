#!/bin/bash 
# DESCRIPCIÓN: Detiene un stack de Docker Compose, fuerza la reconstrucción 
#              de imágenes sin usar caché y despliega los servicios en segundo plano.
# USO:         ./docker_environment_reset.sh <ruta_directorio_compose>


DOCKERCOMPOSE_DIR="$1"
SECONDS=0
#VERIFICAR SI SE PASO UN PARAMETRO

if [ -z "$DOCKERCOMPOSE_DIR" ]; then 
	echo "NO SE RECIBIO NINGUNA RUTA COMO PARAEMTRO"
	exit 1 
fi

#VERIFICAR SI EXISTE EL DIRECTORIO

if [ ! -d "$DOCKERCOMPOSE_DIR" ]; then 
	echo "NO EXISTE EL DIRECTORIO"
	exit 1 
fi 

#VERIFICAR SI EXISTE EL DOCKER COMPOSE

if [ -f "$DOCKERCOMPOSE_DIR/docker-compose.yml" ]; then 
	echo "EL DIRECTORIO CONTIENE UN ARCHIVO docker-compose.yml"
else
	echo "EL DIRECTORIO NO CONTIENE UN ARCHIVO docker-compose.yml"
	exit 1 
fi

#ENTRAR AL DIRECTORIO DONDE ESTA EL DOCKER COMPOSE#
cd "$DOCKERCOMPOSE_DIR" || exit 1

#Accioes 

#Detener docker 
echo "=================================="
echo "DETENIENDO DOCKER COMPOSE"
echo "=================================="
docker compose down
sleep 2


#Forzar recontrunccion de las imagenes 
echo "======================================="
echo "RECONTRUYENDO DOCKER"
echo "======================================="
docker compose build --no-cache 
sleep 2

#Desplegar el stack  

echo "======================================"
echo "DESPLEGAR STACK EN BACKGROUD"
echo "======================================"
docker compose up -d 
sleep 2

#Verificar el estado del stack final 

echo "======================================="
echo "STACK FINAL (STATUS DOCKER)"
echo "======================================="
docker compose ps 
sleep 2

echo "==============================================="
echo "TIMEPO DE RECONSTRUCCION TRANSCURRIDO: $SECONDS segundos"
echo "==============================================="
