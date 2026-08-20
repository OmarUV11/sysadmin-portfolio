#!/bin/bash

NOMBRE_RED="$1"

if [ -z "$NOMBRE_RED"  ];then
	echo "No se paso ningun parametro"
	NOMBRE_RED="app_net"
fi

if ! docker network inspect "$NOMBRE_RED" &>/dev/null; then 
	echo "Error: La red $NOMBRE_RED no existe en el sistema"
	exit 1
fi

DOCKER_ACTIVOS=$(docker ps --format '{{.Names}}')
if [ -z "$DOCKER_ACTIVOS" ]; then
	echo "NO HAY DOCKERS EN EJECUCION"
	exit 0
fi


DOCKERS_ACTIVOS_NETWORK=$(docker network inspect "$NOMBRE_RED" --format '{{range .Containers}}{{.Name}}{{"\n"}}{{end}}')
while read -r docker; do 
	if echo "$DOCKERS_ACTIVOS_NETWORK" | grep -qw "$docker"; then
		echo "El docker $docker esta en la red: $NOMBRE_RED"
	else 
		echo "EL docker $docker no esta en la red"
		echo "Cambiando el docker de red"
		sleep 4
		docker network connect "$NOMBRE_RED" "$docker"
	fi 
done <<< "$DOCKER_ACTIVOS"
