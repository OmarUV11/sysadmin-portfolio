#!/bin/bash 
# DESCRIPCIÓN: Limpia recursos no utilizados de Docker (contenedores parados, 
#              imágenes huérfanas y volúmenes) e informa el espacio liberado.
# USO:         ./docker_system_prune.sh


echo "==================================="
echo "BIENVENIDO AL SISTEMA PRUNE DOCKER"
echo "==================================="

echo "============================================================"
read -p "¿Desea hacer una purga o limpieza del sistema docker Y/n?" respuesta
echo "============================================================"

if [[ "$respuesta" =~ ^[yY]$ ]]; then 
	echo "======================================"
	echo "ESPACIO DE DISCO UTILIZADO ANTES DE LA LIMPIEZA POR DOCKER:"
	echo "======================================"
	docker system df 
	
	echo "Comenzando limpieza del sistema Docker...."
	ESPACIO_LIBERADO=$(docker system prune -a --volumes -f | grep "Total reclaimed space:" | awk -F':' '{print $2}' )
	echo "ESPACIO LIBERADO: $ESPACIO_LIBERADO"	 
	echo ""
	sleep 3
else 
	
	echo "SE SELECCIONO NO"
	echo "Saliendo del script ..."
	sleep 3
	exit 1 
fi

echo "================================"
echo "ESPACIO FINAL DEL SISTEMA DOCKER"
echo "================================"
docker system df 

