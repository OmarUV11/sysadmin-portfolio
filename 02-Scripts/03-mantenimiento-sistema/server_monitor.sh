#!/bin/bash 
#Crea un script diseñado para ejecutarse mediante crontab que guarde en /var/log/server_health.txt un registro formateado de forma limpia con los siguientes datos: fecha y hora actual, tiempo de actividad (uptime), memoria RAM consumida y carga de CPU.
DATE=$(/usr/bin/date '+%Y-%m-%d %H:%M')
UP_TIME=$(/usr/bin/uptime | /usr/bin/awk -F'up ' '{print $2,$3}' | /usr/bin/tr "," " ")
CANT_RAM=$(/usr/bin/free -h | /usr/bin/awk 'NR > 1 ' | /usr/bin/awk  '{print $3}' | /usr/bin/awk  'NR < 2')
CHARGE_CPU=$(/usr/bin/uptime |  /usr/bin/awk  -F'load average:' '{print $2}' )

{
echo "***************************************************************************" 
echo "***************************SALUD DEL SERVIDOR******************************" 
echo "Fecha del servidor: $DATE" 
echo "Tiempo de actividad del servidor: $UP_TIME" 
echo "Total de memoria ram utilizada: $CANT_RAM"
echo "Carga del CPU: $CHARGE_CPU" 
echo "***************************************************************************" 
} |  tee -a  /var/log/server_health.txt
