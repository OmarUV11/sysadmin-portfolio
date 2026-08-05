#!/bin/bash
#Crea un script en Bash que procese un archivo de registro de servidor web (access.log) e imprima un resumen en pantalla indicando: las 5 direcciones IP con más peticiones y el conteo total de respuestas con código de estado HTTP 404 y 500.
FILE_LOG="/var/log/apache2/access.log"
if [ ! -f "$FILE_LOG" ]; then
	echo "El archivo no existe" >&2
	exit 1
fi 

IP_CONT=$(cat "$FILE_LOG" | /usr/bin/awk '{print $1}' |sort | uniq -c | sort -nr | head -n 5 )
echo "Estas los las 5 IPś con mas solicitudes:"
echo "$IP_CONT"

CONT_404=$(awk ' $9 == "404" {cont++} END  {print cont+0}' "$FILE_LOG")
CONT_500=$(awk ' $9 == "500" {cont++} END {print cont+0}' "$FILE_LOG")
echo "Conteo de solicitudes 404 y 500"
echo "Cantidad de solicitudes 404: $CONT_404"
if [ "$CONT_500" -gt 10 ] ; then
	echo -e "\033[31m[PELIGRO] EL TOTAL DE SOLICITUDES 500 SUPERARON LAS 10 PETICIONES\033[0m"
	echo "Saliendo del script..."
	sleep 2
	exit 1
fi
echo "Cantidad de solicitudes 500: $CONT_500"

