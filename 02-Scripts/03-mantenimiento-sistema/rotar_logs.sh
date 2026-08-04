#!/bin/bash 
read -p "Directorio donde estan los logs: " DIR_LOGS
STATIC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUPS="$STATIC_DIR/datos_prueba_mantenimiento/backup_logs"
DATE=$(date "+%Y%m%d")

if [ ! -d "$DIR_LOGS" ]; then 
	echo "El directorio ingresado no existe" >&2
	exit 1
fi

if [ ! -d "$BACKUPS" ]; then
        echo "El directorio no existe" >&2
        sleep 2

        echo "Creando el directorio..."
        mkdir -p "$BACKUPS"
        sleep 2
fi



ARCHIVOS_LOGS=$(find "$DIR_LOGS" -type f -name "*.log" -size +100k)
if [ -z "$ARCHIVOS_LOGS" ]; then 
	 echo "NO se encontraron archivos validos"
	 exit 1
fi

tar -czvf "app_$DATE.log.gz" $ARCHIVOS_LOGS
echo "********************************************************"
echo "********Se creaco el backup de los archivos logs********"
echo "********************************************************"
sleep 2

mv "app_$DATE.log.gz" "$BACKUPS"
echo "Se envio el app_$DATE.log.gz hacia $BACKUPS...."
sleep 2



