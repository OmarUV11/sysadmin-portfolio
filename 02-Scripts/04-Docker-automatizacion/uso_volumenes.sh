#!/bin/bash 
status_volume="$1"
if [ "$#" -eq 0 ]; then 
	echo "No se recibio ningun parametro"
	exit 1
fi

if [ "$status_volume" == "-d" ] || [ "$status_volume" == "--dangling" ] ; then
	echo "=========================================================="
	echo "REPORTE: VOLÚMENES HUÉRFANOS(DANGLING)"
	echo "=========================================================="

	volumes_huerfanos=$(docker volume ls --filter "dangling=true" --format '{{.Name}}')

	if [ -z "$volumes_huerfanos" ]; then
		echo "No encontraron volumenes huerfanos"
	else
		echo "Estos son los volumenes huerfanos: $volumes_huerfanos"
	fi 	
	echo ""
fi


echo -e "\033[34m=============================================="\033[0m
echo -e "\033[34m REPORTE GENERAL DE VOLÚMENES\033[0m"
echo -e "\033[34m=============================================="\033[0m


huerfanos_lista=$(docker volume ls --filter "dangling=true" --format '{{.Name}}')

while read -r volumen; do
    [ -z "$volumen" ] && continue

    # Verificamos si el volumen actual está dentro de la lista de huérfanos
    if echo "$huerfanos_lista" | grep -qw "$volumen"; then
        echo -e "VOLUMEN: $volumen \033[33m[HUÉRFANO / DANGLING]\033[0m"
    else
        echo -e "VOLUMEN: $volumen \033[32m[EN USO]\033[0m"
    fi
done < <(docker volume ls --format '{{.Name}}')

echo ""
