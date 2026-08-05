#!/bin/bash
# DESCRIPCIÓN:  Analiza el archivo access.log de Apache, muestra las 5 IPs con
#               más peticiones y genera recomendaciones de bloqueo si superan
#               un umbral determinado.
set -euo pipefail
DIR="/var/log/apache2"
FILE="$DIR/access.log"
if [ ! -d "$DIR" ]; then
	echo "No existe el directorio" >&2	
	exit 1
fi

if [ ! -f "$FILE" ]; then
	echo "El archivo no existe" >&2
	exit 1
fi

INFO_IP=$(awk '{print $1}' "$FILE" |sort | uniq -c | sort -nr | head -n 5)
echo "Las primeras 5 IP´s con mayor cantidad de solicitudes"
echo "$INFO_IP"
echo "----------------------------------------------------"

PETICIONES_VAL=100;

awk '{print $1}' "$FILE"|sort| uniq -c | while read -r  CONT_SOLICITUDES IP_TOP; do 
	if [ "$CONT_SOLICITUDES" -gt "$PETICIONES_VAL" ]; then
        	echo "[RECOMENDACION] BLOQUEAR IP $IP_TOP en el firewall"
	fi 
done
