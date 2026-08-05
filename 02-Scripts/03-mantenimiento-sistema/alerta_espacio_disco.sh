#!/bin/bash 
# DESCRIPCIÓN:  Monitorea el espacio de la partición raíz (/) y registra una
#               alerta en /var/log si el uso supera el 85%.
cantidad_disco=$(df -h /  |awk 'NR==2 {print $5}' | tr -d '%') 
fecha=$(date "+%Y-%m-%d_%H-%M-%S")
FILE="/var/log/disk_usage${fecha}.log"
	if [ "$cantidad_disco" -gt 85 ]; then
		echo "*ALERTA* El uso del disco supera el 85% de uso, su valor es ${cantidad_disco}%" | tee -a "$FILE" 
	else
		echo "El porcentaje es optimo: ${cantidad_disco}%"
	fi
	
