#!/bin/bash 
# DESCRIPCIÓN:  Lee una lista de servicios desde un archivo y verifica su estado.
#               Si un servicio está caído, intenta reiniciarlo automáticamente.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILE="$DIR/datos_prueba_mantenimiento/servicios.txt"

if [ ! -d "$DIR" ]; then
	echo "No existe el directorio $DIR" >&2
	exit 1
fi

if [ ! -f "$FILE" ]; then
	echo "El fichero $FILE no existe" >&2
	exit 1
fi

while read -r NOMBRE_SERVICIO; do
	if [ -z "$NOMBRE_SERVICIO" ] || [[ "$NOMBRE_SERVICIO" =~ ^# ]]; then
		continue
	fi
	
	
	if systemctl is-active --quiet "$NOMBRE_SERVICIO"  &>/dev/null ; then
		echo "EL servicio $NOMBRE_SERVICIO esta activo" >&2
	else 
		echo "El servicio $NOMBRE_SERVICIO esta inactivo o no existe Reiniciando" 
		sudo systemctl restart "$NOMBRE_SERVICIO" || echo "[ERROR] No se puede reiniciar el servicio"
	fi
done < "$FILE"
