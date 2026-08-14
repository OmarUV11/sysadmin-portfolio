#!/bin/bash 
FILE_LOG="/var/log/system_monitor.log"
DATE=$(date "+%Y-%m-%d_%H:%M")
UMBRAL_PARTITION=85
UMBRAL_RAM=90
UMBRAL_CPU=2.0


#Obtencion de los porcentajes de cada apartado del sistema 
PARTITION_USAGE=$(/usr/bin/df -h / | /usr/bin/awk 'NR>1 {print $5}' | /usr/bin/tr -d "%" | /usr/bin/awk '{ x = int($1); print x}')
RAM_USAGE=$(/usr/bin/free | grep Mem | awk '{ total = int(($3/$2) * 100); print total}')
CPU_USAGE=2.1 #$(/usr/bin/uptime | #awk  -F#'load average:' '{print $2}' #| /usr/bin/tr -d ","# | awk '{print $1}')

{
echo "******************************************************"
echo "**VERIFICACION DEL MONITERO DE RECURSOS DEL SERVIDOR**"
echo "******************************************************"
} >> "$FILE_LOG"


#VERIFICACION DEL ESTADO LA PARTICION /#
if [ $PARTITION_USAGE -lt $UMBRAL_PARTITION ]; then
	echo "[INFO-$DATE]-El uso de la particion '/' del servidor esta dentro de los margenes normales: $PARTITION_USAGE%" >> "$FILE_LOG"
else 
	echo "[ALERTA-$DATE]-El uso de la particion '/' esta en estado critico" >> "$FILE_LOG"
fi


#VERIFICACION DEL USO DE RAM DEL SERVIDOR#

if [ $RAM_USAGE -lt $UMBRAL_RAM ]; then 
	echo "[INFO-$DATE]-El uso de la Ram del servidor esta en los margenes normales: $RAM_USAGE%" >> "$FILE_LOG"

else 
	echo "[ALERTA-$DATE]-El uso de la Memoria Ram esta fuera de los margenes permitidos: $RAM_USAGE%" >> "$FILE_LOG"
fi



CPU_STATUS=$(echo "$CPU_USAGE $UMBRAL_CPU" | awk '{ if ($1 > $2) print 1; else print 0}')
#VERIFICACION DEL CPU#
if [ "$CPU_STATUS" -eq 0 ]; then
	echo "[INFO-$DATE]-EL tiempo de carga del cpu esta en el tiempo permitido: $CPU_USAGE" >> "$FILE_LOG"
else
	echo "[ALERTA-$DATE]-El tiempo de carga cpu supero el umbral $UMBRAL_CPU" >> "$FILE_LOG"
fi
