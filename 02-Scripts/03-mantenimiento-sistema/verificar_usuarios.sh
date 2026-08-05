#!/bin/bash 
#Lee un archivo de texto con una lista de nombres de usuario por línea (ejemplo: root, admin, usuario_falso). Verifica si el usuario existe en el sistema. Si existe, guarda su nombre en el archivo usuarios_validos.log; si no existe o no tiene acceso, lanza una advertencia en la salida de errores (2>).
STATIC_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILE="$STATIC_FILE/datos_prueba_mantenimiento/usuarios_validos.txt"
LOG_FILE="/var/log/usuarios_validos.log"
if [ ! -f "$FILE" ];then 
	echo "No existe el archivo $FILE " >&2
	exit 1
fi 


while read -r USUARIO; do 
	if [ -z "$USUARIO" ] || [[ "$USUARIO" =~ ^# ]]; then
		continue
	fi
	if id "$USUARIO" &>/dev/null; then
		echo "[CONFIRMADO] EL USUARIO $USUARIO EXISTE" >> "$LOG_FILE"
	else
		echo "[DENEGADO] EL USUARIO $USUARIO NO EXISTE" >&2
	fi
done < "$FILE"
