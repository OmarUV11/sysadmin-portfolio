#!/bin/bash 

FLAG_EXE="$1"
#Umbrales#
MAX_CPU=80
MAX_MEM=75

FILE_LOG=/var/log/docker_alerts.log

#Fecha de registro#
DATE=$(date '+%Y-%m-%d %H:%M:%S')

#Verificar si se esta pasando un parametro 
if [ -z "$FLAG_EXE" ]; then 
        echo "=================================="
        echo "No paso ningun parametro al script"
        echo "=================================="
fi

#Limpiar archivo 

if [ "$FLAG_EXE" == "-c" ] || [ "$FLAG_EXE" == "--clean" ]; then 
	read -p "¿Quiere limpiar el archivo $FILE_LOG? [S/n]" answer
	if [ "$answer" == "s" ] || [ "$answer" == "S" ]; then
		echo "Limpiando el archivo..." 
		sudo truncate -s 0 "$FILE_LOG"
		sleep 3

		echo "Se ha limpiado el archivo"
	else

		echo "Continuando con la ejecucion del script"
		clear 
	fi
	 

fi


#Verifiars si existen dockers mediante stats#
DOCKERS=$(docker stats --no-stream --format '{{.Name}} {{.CPUPerc}} {{.MemPerc}} ' | tr -d '%')
if [ -z "$DOCKERS" ]; then 
	echo "========================================"
	echo "No existen dockers que revisar su estado"
	echo "========================================"
	exit 0 
fi

       


while read -r stats_nombre stats_cpu stats_mem; do 
	 if [ "$(echo  "$MAX_MEM < $stats_mem"  | bc)" -eq 1 ] || [ "$(echo "$MAX_CPU < $stats_cpu" | bc)" -eq  1  ]; then
		echo "[ADVERTENCIA] El contenedor: $stats_nombre supero los limites (CPU: $stats_cpu | Max: $MAX_CPU | MEM: $stats_mem | MAX: $MAX_MEM)"
		echo "[$DATE] [ALERTA] Contenedor: $stats_nombre |  CPU: $stats_cpu% | RAM: $stats_mem%" | sudo  tee -a "$FILE_LOG"
	 fi
done <<< "$DOCKERS"

