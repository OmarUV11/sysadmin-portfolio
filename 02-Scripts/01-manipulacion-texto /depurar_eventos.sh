#!/bin/bash
#Crea un script que analice un archivo de registro de sistema (syslog.log). El script debe filtrar únicamente los eventos clasificados como ERROR o CRITICAL y guardarlos en un archivo de salida llamado eventos_criticos.log dentro de la carpeta datos_prueba/. 
RELATIVE_RUTE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
FILE="$RELATIVE_RUTE/datos_prueba/syslog.log"

if [ ! -f "$FILE" ]; then 
	echo "El archivo no existe" >&2
	exit 1
fi

grep -E -i "(ERROR|CRITICAL)" "$FILE" > "$RELATIVE_RUTE/datos_prueba/eventos_criticos.log"
echo "Se genero el archivo eventos_criticos.log"

EVENTOS_CRITICOS=$(awk '/(CRITICAL|ERROR)/ {print $0}' "$FILE" | wc -l)
echo "************************************************"
echo "Cantidad de eventos CRITICOS: $EVENTOS_CRITICOS" 
sleep 2
echo "La ruta  del archivo es: $RELATIVE_RUTE/datos_prueba/eventos_criticos.log"


