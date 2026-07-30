#!/bin/bash
#Crea un script llamado filtrar_errores.sh que reciba un archivo de log de aplicación (app.log). El script debe buscar todas las líneas que contengan eventos de tipo ERROR, CRITICAL o FATAL (sin importar si están en mayúsculas o minúsculas) y guardarlas en un archivo separado errores_detectados.log. 
INFO_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILE="$INFO_FILE/datos_prueba/app.log"
echo "$FILE"
if [ ! -f "$FILE" ]; then 
	echo "El archivo no existe" >&2
	exit 1
fi
FILE_LOG="errores_detectados.log"
grep  -i -E '(ERROR|CRITICAL|FATAL)' "$FILE" > "$INFO/$FILE_LOG"

TOTAL_LINEAS=$(wc -l "$FILE_LOG" | awk '{print $1}')
echo "Total de lineas con errores: $TOTAL_LINEAS"
