#!/bin/bash
ID_NOMBRE_DOCKER="$1"
VAL_ENTORNO="$2"
if [ -z "$ID_NOMBRE_DOCKER" ];then 
	echo "======================================="
	echo "NO SE PASO NINGUN ID O NOBRE DE DOCKER"
	echo "======================================="
	exit 1
fi

#Verificacion del estado del docker#
DOCKER_STATUS=$(docker inspect "$ID_NOMBRE_DOCKER" --format '{{.State.Status}}')
if [ "$DOCKER_STATUS" == "running" ];then 
	echo "======================================================================================================"
	echo "EL docker con el ID O NOMBRE: $ID_NOMBRE_DOCKER  esta en ejecucion ya que su estado en: $DOCKER_STATUS"
	echo "======================================================================================================"
	echo ""
	sleep 4
else 
	echo "==============================="
	echo "EL docker no esta en ejecucion"
	echo "==============================="
	exit 1 
fi


#Verificacion si solo recibe el nombre 

if [ ! -z "$ID_NOMBRE_DOCKER" ] && [ -z "$VAL_ENTORNO" ]; then
	echo "================================================================="
	echo "SOLO SE PASO EL NOMBRE DEL DOCKER ESTAS SON LAS VARIBLES ENTORNO DEL DOCKER ($ID_NOMBRE_DOCKER)"
	echo "================================================================="
	docker inspect "$ID_NOMBRE_DOCKER" --format '{{range .Config.Env}}{{println .}}{{end}}' 

elif [ ! -z "$VAL_ENTORNO" ]; then
	VALOR_ENV=$(docker inspect "$ID_NOMBRE_DOCKER" --format '{{range .Config.Env}}{{println .}}{{end}}' | grep  "^${VAL_ENTORNO}=" | cut -d'=' -f2- )
	if [ -z "$VALOR_ENV" ]; then 
		echo "======================================="
		echo "La variable no existe en el contenedor"
		echo "======================================="
		exit 1
	else
		echo "Este es el valor de la variable de entorno $VAL_ENTORNO: $VALOR_ENV"
	fi
fi 



