#!/bin/bash 
#Crea un script que tome una carpeta de origen (por ejemplo, /home/usuario/documentos) y genere un archivo comprimido .tar.gz en una carpeta de destino llamada /backup. El nombre del archivo debe incluir la fecha y hora exacta (ej. backup_2026-07-17_19-30.tar.gz). Al finalizar, debe imprimir el tamaño del archivo generado.
if [ "$#" -ne 2 ]; then
	echo "Uso $0 <RUTA ORIGEN> <RUTA DESTINO>" >&2
	exit 1
fi

fecha=$(date "+%Y-%m-%d_%H-%M")
RUTA_ORIGEN="$1"
RUTA_DESTINO="$2"
NOMBRE_ARCHIVO="backup_$fecha.tar.gz"
RUTA_FINAL="${RUTA_DESTINO}/${NOMBRE_ARCHIVO}"

if [ ! -d "$RUTA_ORIGEN" ]; then
	echo "[ERROR] El directorio de origen '$RUTA_ORIGEN' no existe." >&2
	exit 1
fi


if [ ! -d "$RUTA_DESTINO" ]; then 
	echo "[ERROR] El directorio de destino '$RUTA_DESTINO' no existe." >&2
	mkdir -p "$RUTA_DESTINO"
fi

tar -cvzf "$RUTA_FINAL" "$RUTA_ORIGEN" 2>/dev/null || sudo tar -czf "$RUTA_FINAL" "$RUTA_ORIGEN"  
salida=$(du -h "$RUTA_FINAL" | awk '{print $1}')
echo "El tamaño del respaldo $NOMBRE_ARCHIVO es de: $salida"

