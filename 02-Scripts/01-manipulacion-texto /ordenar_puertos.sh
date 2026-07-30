#!/bin/bash 
ordenar_puertos(){
	local FILE_LOCAL=$1 
	local DIR_LOCAL=$2
	sort -u -n "$FILE_LOCAL" > "$DIR_LOCAL/datos_prueba/puertos_unicos.txt"
}

DIR_DINAMIC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILE="$DIR_DINAMIC/datos_prueba/puertos_abiertos.txt"
if [ ! -f "$FILE" ]; then
	echo "El archivo no existe" >&2
	exit 1 
fi

ordenar_puertos "$FILE" "$DIR_DINAMIC"
echo "Se creo el archivo puertos_unicos.txt"

