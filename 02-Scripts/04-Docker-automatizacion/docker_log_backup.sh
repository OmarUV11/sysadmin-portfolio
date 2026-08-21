#!/bin/bash
STATIC_RUTE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NOMBRE_ID_DOCKER="$1"
NOMBRE_DIR="$2"
DEFAULT_DIR="/backups/docker_logs"
DATE_TIME=$(date '+%Y%m%d_%H%M%S')

if [ -z "$NOMBRE_ID_DOCKER" ]; then 
	echo "=========================================="
	echo "NO SE PASO UN ID O NOBRE DEL DOCKER VALIDO"
	echo "=========================================="
	exit 1 
fi

if [ -z "$NOMBRE_DIR" ]; then 
	NOMBRE_DIR="$DEFAULT_DIR"
fi 

if [ ! -d "$NOMBRE_DIR" ]; then 
	sudo mkdir -p "$NOMBRE_DIR"
fi


#Obtner la rutas absolutas de los archivos losgs#

FILE_LOGS=$(docker inspect "$NOMBRE_ID_DOCKER" --format '{{.LogPath}}')

#Generelo respaldo del archivo log del docker 
LOG_DIR=$(dirname "$FILE_LOGS")
LOG_FILE=$(basename "$FILE_LOGS")
sudo tar -czf "$NOMBRE_DIR/${DATE_TIME}_${NOMBRE_ID_DOCKER}.tar.gz" -C "$LOG_DIR" "$LOG_FILE" 


ls -1t "$NOMBRE_DIR"/*_${NOMBRE_ID_DOCKER}.tar.gz 2>/dev/null | tail -n +6 | xargs -r sudo rm -f 
