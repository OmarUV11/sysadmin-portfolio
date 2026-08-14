#!/bin/bash
#SCRIPT: stats_contenedor.sh
#UBICACION: 04-Docker_automatizacion/
#DESCRIPCION: Muestra metricas del CPU, RAM y RED de un conteneodor activo
#USO ./stats_contenedor.sh <NOMBRE O ID DEL CONTENEDOR>
#
#****************************************************************************************************
if [ "$#" -ne 1 ];then
	echo -e "\033[31m--------------------------------------------\033[0m"
	echo -e "\033[31mNo se paso ningun parametro como nombre o ID\033[0m" >&2
	echo -e "\033[31m--------------------------------------------\033[0m"
	exit 1
fi

DOCKER_NAME_ID="$1"

#Verificacion de la existencia y funcionamiento del docker#
STATUS_DOCKER=$(docker inspect "$DOCKER_NAME_ID" -f '{{.State.Running}}' 2>/dev/null)
if [ "$STATUS_DOCKER" != "true" ] ; then
	echo -e "\033[31mEL docker: $DOCKER_NAME_ID no existe o esta detenido\033[0m" >&2
	exit 1
else 
	echo -e "\033[32mEl docker: $DOCKER_NAME_ID existe y esta activo\033[0m"
fi


#Lectura de las metricas

DOCKER_STATS=$(docker stats --no-stream "$DOCKER_NAME_ID" --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}")

echo -e "*********************************************"
echo "STATS ESTILIZADOS DEL DOCKER: $DOCKER_NAME_ID"
echo "*********************************************"
echo "$DOCKER_STATS"

