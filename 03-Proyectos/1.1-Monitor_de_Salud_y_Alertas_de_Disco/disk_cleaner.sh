#!/bin/bash
#==============================================================================================================
#Script: disk_cleaner
#Proyecto: Proyecto 1.1 - Monitorear la salud y alertas de Disco
#Descripcion:	Monitorea el uso de la particion raiz (/).
#		Si el uso supera o es igual a un umbral el estado es critico, es por 	
#		eso que se deben de ejecutar rutinas de emergencia (limpieza de paquetes huerfanos, cache y truncado de logs antiguos 
#Auditoria 	Registra cada evento en un archivo log ubicado en /var/log/sysadmin_clean.log
#===============================================================================================================
DISK_STATUS=$(df -h / | awk 'NR>1 {print $5}' | tr -d "%" | awk 'BEGIN { x = int($1); print x }')
UMBRAL=85
DATE=$(date  "+%F-%H-%M-%S")
NOMBRE_ARCHIVO_LOG="sysadmin_clean.log"
RUTA_DEFECTO="/var/log/$NOMBRE_ARCHIVO_LOG"


#Rutinas de emergencia
eliminar_paquetes(){
	sudo /usr/bin/apt autoremove -y &>/dev/null
	echo -e "*[$DATE-INFO]Se eliminaron paquetes huerfanos*"
	sleep 3
}

limpiar_cache(){
	sudo /usr/bin/apt autoclean -y &>/dev/null
	echo  "*[$DATE-INFO]Se hizo una limpieza de cache*"
	sleep 3  
}

truncar_archivos_log(){
	sudo /usr/bin/find / -type f  -name "*.log" ! -name   "$NOMBRE_ARCHIVO_LOG" -mtime +30 | while read -r nombres; do 
		echo "[$DATE-INFO] El archivo log : $nombres tiene mas de 30 dias"
		echo "[$DATE-INFO] Se realizara la disminuacion de contenido al archivo: $nombres "
		/usr/bin/truncate -s 0 "$nombres"
		sleep 4
	done 
	echo -e "[$DATE-CONFIRMACION] Se realizo la disminucion en los archivos"	
}



#Revision del estado de la particion 
if [ $DISK_STATUS -gt $UMBRAL ]; then
	{ 
	echo "---------------------------------------------------------"
	echo "[$DATE-ALERTA] USO DE LA PARTICION RAIZ ES CRITICO"
	echo "--------------------------------------------------------"	
	echo "[$DATE-ALERTA] Ejecutando rutinas de emergencia"
	eliminar_paquetes  # Llamada a la funcion de rutinas de emergencia
	limpiar_cache # Llamada a la funcion de rutinas de emergencia 
	truncar_archivos_log
	}  >> "$RUTA_DEFECTO"

elif [ $DISK_STATUS -le $UMBRAL ]; then
	{
	echo  "----------------------------------------------------------------"
	echo  "[INFO-$DATE] El uso de la particion raiz del servidor es estable"
	echo  "----------------------------------------------------------------"
	} >> "$RUTA_DEFECTO"
	exit 0 
fi

