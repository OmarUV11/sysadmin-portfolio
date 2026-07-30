#!/bin/bash 
#Crea un script que lea una copia del archivo de usuarios (passwd.txt). El script debe contar y mostrar cuántos usuarios tienen asignada cada shell en el sistema (ej. /bin/bash, /usr/bin/zsh, /sbin/nologin, /bin/false), ordenando el resultado de mayor a menor frecuencia.

STATIC_RUTE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILE_RUTE="$STATIC_RUTE/datos_prueba/passwd.txt"
if [ ! -f "$FILE_RUTE" ]; then
	echo "No existe el archivo" >&2
	exit 1
fi

echo "***************************************************"
awk -F ':' '{print $7}' "$FILE_RUTE" | sort | uniq -c | grep -e /bin/bash -e /usr/bin/zsh -e /sbin/nologin -e /sbin/nologin/ -e /bin/false | sort -nr | while read -r cont_usr shell; do
	echo "Cantidad: $cont_usr - Shell: $shell"
done 
echo "**************************************************"


CONT_AUDITORIAS=$(wc -l < "$FILE_RUTE")
echo "*********************************************"
echo "Total de cuentas auditadas: $CONT_AUDITORIAS"
echo "*********************************************"
