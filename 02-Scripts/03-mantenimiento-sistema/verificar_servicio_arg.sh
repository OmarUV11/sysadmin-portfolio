#!/bin/bash 
#Instrucción: Recibe el nombre de un servicio por argumento ($1). Verifica si está activo usando systemctl. Si está activo, muestra un mensaje en verde; si está caído, intenta reiniciarlo y registra el evento usando $?
SERVICE="$1" 
if [ "$#" -ne 1 ]; then
        echo -e "\e[31m[Error] Uso: $0 <nombre del servicio> \e[0m" >&2
        exit 1
fi
systemctl is-active --quiet $SERVICE 
SALIDA=$?
if [ "$SALIDA" -ne 0 ]; then
	sudo systemctl restart $SERVICE
	SERVICE_INTENTO=$?
	if [ $SERVICE_INTENTO -eq 0 ]; then
		echo  -e "\e[32m El servicio $SERVICE se reinicio correctamen \e[0m"
	else 
		echo  -e "\e[31m El servicio $SERVICE sigue sin funcionar \e[0m"
		logger -t REGISTRO_SERVICIO "FALLO CRITICO EN EL SERVICIO $1"
	fi
else
	echo -e "\e[32m El servicio esta funcionando \e[0m"
fi 



