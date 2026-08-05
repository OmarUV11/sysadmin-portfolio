#!/bin/bash 
# DESCRIPCIÓN:  Copia la configuración de Apache, genera un respaldo .bak
#               y modifica el parámetro KeepAlive usando sed.
#GENERAR COPIA LOCAL#
DIR_STATIC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
RUTA_ARCHIVO="/etc/apache2/"
ARCHIVO_ORIGINAL="/etc/apache2/apache2.conf"
RUTA_DESTINO="$DIR_STATIC/scripts_basicos_git/"
NOMBRE_ARCHIVO="apache2.conf"

if [ ! -d "$RUTA_ARCHIVO" ]; then
	echo "EL directorio no existe"
	exit 1
fi

if [ ! -f "$ARCHIVO_ORIGINAL" ]; then 
	echo "El archivo $ARCHIVO_ORIGINAL no existe" >&2
	exit 1
fi

mkdir -p "$RUTA_DESTINO"
cp "$ARCHIVO_ORIGINAL" "$RUTA_DESTINO"


RUTA_FINAL="$RUTA_DESTINO$NOMBRE_ARCHIVO"
if [ ! -f "$RUTA_FINAL" ]; then
	echo "EL archivo no existe"
	sleep 2
	exit 1
fi 


echo "**Se creo el respaldo del archivo**"
cp "$RUTA_FINAL" "$RUTA_FINAL".bak
echo "**********************************"
sleep 2


echo "Modificando el archivo de configuracion...."
sed -i 's/KeepAlive On/KeepAlive Off/' "$RUTA_FINAL"
sleep 3

echo "********************"
echo "Modificacion exitosa"
