#!/bin/bash 
#Crea un script llamado top_ips.sh que lea un archivo de log de servidor web (access.log). El script debe extraer la primera columna (la dirección IP del cliente) y mostrar en pantalla únicamente las 5 direcciones IP con más solicitudes, junto con el total de peticiones de cada una, ordenadas de mayor a menor.
STATIC_RUTE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
RUTE_FILE="$STATIC_RUTE/datos_prueba/access.log"

if [ ! -f "$RUTE_FILE" ]; then
	echo "EL archivo no existe" >&2
	exit 1
fi
printf "%-15s %-10s %-8s\n" "SOLICITUDES"       "IP´s"
printf "%-15s %-10s %-8s\n" "-----------"	"-----"
awk '{print $1}' "$RUTE_FILE" | sort | uniq -c | sort -nr | head -5 | awk '{print $1}' | while read -r SOLICITUDES IP; do 
	printf "%-15s %-10s %-8s\n" "$SOLICITUDES" "$IP" 
done





