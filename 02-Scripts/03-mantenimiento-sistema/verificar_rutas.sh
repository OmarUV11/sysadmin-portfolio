#!/bin/bash 
#Lee un archivo de texto con una lista de rutas absolutas de archivos o directorios por línea (ejemplo: /etc/passwd, /var/log, /ruta/falsa). Verifica si la ruta existe en el sistema. Si existe, muestra un mensaje de confirmación por la salida estándar; si no existe, lanza una advertencia en la salida de errores (2>).
STATIC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
FILE="$STATIC_DIR/datos_prueba_mantenimiento/rutas.txt"
if [ ! -f "$FILE" ]; then
	echo "No existe el archivo" >&2
	exit 1
fi


while read -r RUTA; do 
	if [ -z "$RUTA" ] || [[ "$RUTA" =~ ^# ]]  ; then
		continue	
	fi
	
	if [ -e "$RUTA" ] ;then
		echo "La ruta : $RUTA  existe en el sistema"
	else 	
		echo "La ruta : $RUTA  No existe en el sistema [STDERR]" >&2
	fi

done < "$FILE"
	
