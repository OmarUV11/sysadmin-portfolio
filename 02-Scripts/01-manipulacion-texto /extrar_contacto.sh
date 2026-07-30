#!/bin/bash 
FILE_RUTE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
FILE="$FILE_RUTE/datos_prueba/empleados.csv"
if [ ! -f "$FILE" ]; then 
	echo "El archivo no existe" >&2
	exit 1
fi

cut -d',' -f2-3 "$FILE" | awk -F',' 'cut -d',' -f2-3 empleados.csv | awk -F ',' 'NR>1 {print $1, "<"$2">"}''  > "$FILE/datos_prueba/directorio_contacto.txt"
