#!/bin/bash
#Crea un script que lea el archivo passwd.txt. El script debe filtrar únicamente los usuarios cuyo UID sea mayor o igual a 1000 (usuarios regulares del sistema, excluyendo cuentas de servicio o de sistema) y mostrar en pantalla su Nombre de usuario, UID y Directorio Home alineados en formato de tabla.

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
FILE="$DIR/datos_prueba/passwd.txt"
if [ ! -f "$FILE" ]; then 
	echo "No existe el archivo" >&2
	exit 1 
fi

TOTAL_USUARIOS=$(awk -F':' '$3>=1000 {print $0}' "$FILE" | wc -l)
echo "++++++++++++++++++++++++++++++++++++++++++++"
echo "Total de usuarios normales: $TOTAL_USUARIOS"
echo "++++++++++++++++++++++++++++++++++++++++++++"

printf "%-15s %-10s %-25s\n" "usuario" "UID" "Directorio Home"
printf "%-15s %-10s %-25s\n" "------"  "---" "---------------"
awk -F':' '$3 >=1000 {print $1"\t"$3"\t"$6}' "$FILE" | while read -r usuario uid directorio; do
	printf "%-15s %-10s %-25s\n" "$usuario" "$uid" "$directorio"
done

