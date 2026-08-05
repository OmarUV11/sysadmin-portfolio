#!/bin/bash 
#Crear un script para auditar un archivo de registro web (estándar Apache/Nginx) que analice las métricas de peticiones y extraiga el top de direcciones IP.
read -p "Servicio web para analizar sus logs: " SERVICIO_WEB
FILE_LOG="/var/log/$SERVICIO_WEB/access.log"
if [ ! -f "$FILE_LOG" ]; then
	echo "El archivo access.log no existe" >&2
	exit 1
fi

PETICIONES_200=$(awk '$9=="200" {count++} END {print count+0}' "$FILE_LOG")
PETICIONES_404=$(awk '$9=="404" {count++} END {print count+0}' "$FILE_LOG")
CONT_IPS=$(awk '{print $1}' "$FILE_LOG" | sort | uniq -c | sort -nr | head -3)
TOTAL_PETICIONES=$(awk '{print $1,$9} ' "$FILE_LOG" | wc -l)
echo "********************LOGS DEL SERVICIO ($SERVICIO_WEB)************************"
echo "*****************************************************************************"
echo "TOTAL DE PETICIONES: $TOTAL_PETICIONES"
echo "TOTAL DE PETICIONES 200: $PETICIONES_200"
echo "TOTAL DE PETICIONES 404: $PETICIONES_404"
echo "*****************************************************************************"

echo "***********IP´s con solicitudes:***************"
echo "$CONT_IPS"
