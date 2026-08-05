#!/bin/bash 
#Inspecciona /etc/passwd leyendo campo por campo con IFS=':'
#y muestra los usuarios que tienen asignada una shell interactiva
#(/bin/bash o /bin/sh).
set -euo pipefail
FILE="/etc/passwd"
if [ ! -f "$FILE" ]; then
	echo "El archivo $FILE  no existe" >&2
	exit 1

fi

while IFS=':' read nombre pass uid gid informacion home shell; do
	if [ "$shell" == "/bin/sh" ] || [ "$shell" == "/bin/bash" ]; then
		echo "Usuario: $nombre  | home: $home"
	fi
done < "$FILE"
