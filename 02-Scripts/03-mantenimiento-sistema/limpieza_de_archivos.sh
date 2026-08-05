#!/bin/bash 
#Busca en una carpeta específica todos los archivos .log o .tmp con más de 7 días de antigüedad y elimínalos. Antes de borrar, registra en limpieza.log cuántos archivos se van a eliminar.
FOLDER=$1
LOG_FILE="/var/log/limpieza.log"
DATE=$(date "+%Y-%m-%d %H-%M")
if [ -z "$FOLDER" ] || [ ! -d "$FOLDER" ]; then
	echo "Error: el directorio proporcinado no existe " >&2
	echo "Uso de $0 /rutas/del/directorio" >&2
	exit 1
fi
 
CONT_FILES=$(find "$FOLDER" -mtime +7 \( -name "*.log" -o -name "*.tmp" \) | wc -l )  

if [ "$CONT_FILES" -eq 0 ]; then
	echo "No se encontraron archivos expirados en : $FOLDER"
	exit 0
fi


echo "Eliminando $CONT_FILES archivos expirados en '$FOLDER'..."

echo "$DATE - Se eliminaron $CONT_FILES  archivo expirados en $FOLDER" >> "$LOG_FILE"

find "$FOLDER" -mtime +7 \( -name "*.log" -o -name "*.tmp" \) -delete
echo "[OK] LIMPIEZA COMPLETADA.."
