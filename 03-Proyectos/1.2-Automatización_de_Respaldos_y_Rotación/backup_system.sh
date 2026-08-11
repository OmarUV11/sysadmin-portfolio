#!/bin/bash
#================================================================================================
#Script: backup_system.sh 
#Proyecto: Proyecto 1.2 Sistema Automatizado de Respaldos y Rotación (Backups)
#Descripcion: 	Desarrollo e implementación de un script en Bash diseñado para automatizar las tareas críticas de administración de sistemas: respaldos periódicos de la configuración del sistema (/etc) y de las aplicaciones web (/var/www/html), auditoría centralizada en logs y purga automática por políticas de retención.

#Auditoria: Gestion de archivos  de regristros log, donde se trasan cada ejecucion del script  , donde se muestran la modificaciones
#del sistema [INICIO][EXITO][RESPALDOS ELIMINADOS].
#=================================================================================================
 
date=$(date '+%Y%m%d_%H%M%S')
dir_config="/etc"
dir_aplicaciones="/var/www/html"
dir_back="backups"
archivo_log="backup_sysadmin.log"

#Verificacion para el directorio backups
if [ ! -d "$dir_back" ]; then 
	echo "[INICIO] EL directorio: $dir_back no existe" >> "/var/log/$archivo_log" 
	sleep 3

	echo "[INICIO] Creando el directorio...." >> "/var/log/$archivo_log"
	mkdir -p "$dir_back"

	sleep 3
	echo "[EXITO] EL directorio: $dir_back se a creado" >> "/var/log/$archivo_log"
fi

#Verificacion para el directorio etc y html 
if [ ! -d "$dir_config" ] || [ ! -d "$dir_aplicaciones" ];then
	echo "[FALLO] EL directorio $dir_config o $dir_aplicaciones no existe" >> "/var/log/$archivo_log"
	exit 1 
fi


#Realizando el respaldo del directorio etc

tar -czvf "backup_$date.tar.gz" "$dir_config" "$dir_aplicaciones" && mv "backup_$date.tar.gz" "$dir_back" &>/dev/null


if [ $? -eq 0 ]; then 
	echo "[EXITO] El respaldo se realizo correctamete, se movera la carpeta '$dir_back'" >> "/var/log/$archivo_log"
	sleep 4
	echo "[EXITO] Se movio el respaldo: backup_$date.tar.gz hacia $dir_back" >> "/var/log/$archivo_log"
	size_file=$(du -sh "$dir_back/backup_$date.tar.gz" | awk '{print $1}')
	echo "[TAMAÑO DEL BACKUP GENERADO] $size_file"	>> "/var/log/$archivo_log"

else  
	echo "EL archivo que se intenta mover no existe o hubo un fallo al momento de realizar la compresion">> "/var/log/$archivo_log"
	rm  -f "backup_$date.tar.gz"
	sleep 2
	exit 1
	
fi


#Verificaion de antiguedad de respaldos 
echo "[RESPALDOS ELIMINACION] Ejecutando politicas de rotacion y eliminacion" >> "/var/log/$archivo_log"
find "$dir_back" -type f -name "*.tar.gz" -mtime +7  | while read -r nombres ; do
	if [ -n "$nombres" ]; then 
		echo "[RESPALDOS ELIMINADOS] Este respaldo fue eliminado por antiguedad de 7 dias: $nombres" >> "/var/log/$archivo_log"
		rm -f "$nombres"
	fi 
done


