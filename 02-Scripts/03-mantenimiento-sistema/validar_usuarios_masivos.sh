#!/bin/bash
#Lee una lista de nombres de usuario desde un archivo de texto, 
#omite comentarios y líneas vacías, y verifica si cada usuario 
#ya existe en el sistema antes de simular su creación.
STATIC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILE="${1:-$STATIC_DIR/nombres_de_usuario.txt}"
while read -r NOMBRES_DE_USUARIO; do
	if [ -z "$NOMBRES_DE_USUARIO" ] || [[ "$NOMBRES_DE_USUARIO" =~ ^# ]]; then
		continue
	fi 
	
	if id "$NOMBRES_DE_USUARIO" &>/dev/null; then 
		echo "Advertencia: EL usuario $NOMBRES_DE_USUARIO ya existe" >&2
	else
		echo "Simulando creacion de usuario $NOMBRES_DE_USUARIO..."
	fi

done < "$FILE" 


