#!/bin/bash 
#SCRIPT:          04-Docker-automatizacion/backup_volumenes.sh
#DESCRIPCIÓN:     Realiza copias de seguridad comprimidas (.tar.gz) de los 
#                 volúmenes de Docker hacia un directorio local. Permite 
#                 filtrar únicamente los volúmenes huérfanos (dangling) o 
#                 respaldar la totalidad de los volúmenes del sistema.

PARAMETRO="$1"
#Obtener lista de volumenes huerfanos 

#Verificacion del parametro 
if [ "$PARAMETRO" == "-d" ] || [ "$PARAMETRO" == "--dangling" ]; then
	echo "=================================================="
	echo "LISTADO DE LOS VOLUMENOS HUERFANOS"
	echo "================================================="
	VOL_HUERFANOS=$(docker volume ls --filter "dangling=true" --format '{{.Name}}')
else
	echo "============================"
	echo "LISTA DE VOLUMENES COMPLETA:"
	echo "============================"
	VOL_HUERFANOS=$(docker volume ls --format '{{.Name}}')
fi

#Verifiacion de que se tienen volumenes 
if [ -z "$VOL_HUERFANOS" ]; then 
	echo "No se encontraron volumenes existentes"
	exit 0
fi

echo "$VOL_HUERFANOS"
echo ""
#Verificacion de la carpeta 

DIR_NAME_BACK="backups"
echo "==================================================="
echo "Verificando existencia del directorio $DIR_NAME_BACK"
echo "==================================================="
sleep 4
if [ ! -d "$DIR_NAME_BACK" ]; then
	echo "NO EXISTE EL DIRECTORIO"
	echo "CREANDO EL DIRECTORIO..."
	mkdir -p "$DIR_NAME_BACK"
else
	echo "El directorio ya existe"
fi


#Recorrido de los  volumenes obtenidos


while read -r volumenes_names; do 
	echo "Generando el respaldo del volumen: $volumenes_names"
	docker run --rm  \
	-v "$volumenes_names":/volume:ro \
	-v $(pwd)/backups:/backup \
	alpine tar -czf /backup/"$volumenes_names".tar.gz -C /volume .

done <<< "$VOL_HUERFANOS"
