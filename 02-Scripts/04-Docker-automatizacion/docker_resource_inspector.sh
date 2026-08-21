#!/bin/bash
# DESCRIPCIÓN: Revisa un contenedor Docker en ejecución para extraer y mostrar 
#              sus puertos mapeados al Host y sus volúmenes/montajes asignados.
# USO:         ./docker_resource_inspector.sh <nombre_o_id_contenedor>

ID_NOMBRE_DOCKER="$1"

if [ -z "$ID_NOMBRE_DOCKER" ]; then 
	echo "NO SE RECIBIO NINGUN ARGMUENTO"
	exit 1 
fi


#Verificacion del estado del script #

STATUS_DOCKER=$(docker inspect "$ID_NOMBRE_DOCKER" --format '{{.State.Running}}')
if [ "$STATUS_DOCKER" == "true" ]; then 
	echo "=========================================="
	echo "EL DOCKER:$ID_NOMBRE_DOCKER ESTA EJECUCION"
	echo "=========================================="
else 
	echo "================================================"
	echo "EL DOCKER:$ID_NOMBRE_DOCKER NO ESTA EN EJECUCION"
	echo "================================================"
	exit 1
fi


#Obtener puertos mapeados#
PUERTOS_MAPEADOS=$(docker inspect --format '{{range $p, $conf := .NetworkSettings.Ports}}{{$p}} ->  {{if $conf}}{{(index $conf 0).HostPort}}{{"\n"}}{{end}}{{end}}' "$ID_NOMBRE_DOCKER" 2>/dev/null)
if [ -z "$PUERTOS_MAPEADOS" ]; then 
	echo "NO TIENE PUERTOS MAPEADOS"
else
	echo "=======PUERTOS MAPEADOS======="
	echo "$PUERTOS_MAPEADOS"
fi

#Obtener volumenes 
VOL_DOCKER=$(docker inspect --format '{{range .Mounts}}{{.Source}} -> {{.Destination}}{{"\n"}}{{end}}' "$ID_NOMBRE_DOCKER")
if [ -z "$VOL_DOCKER" ]; then 
	echo "EL DOCKER NO TIENE VOLUMENS ASIGNADOS"
else 
	echo "==========VOLUMENES ASIGANADOS=========="
	echo "$VOL_DOCKER"

fi
	
