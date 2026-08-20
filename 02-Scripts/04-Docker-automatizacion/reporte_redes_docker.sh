#!/bin/bash 

while read -r networks_docker; do 
	echo "RED_DOCKER: $networks_docker"

	network_docker=$(docker inspect "$networks_docker" --format '{{ range .Containers}}{{.Name}} - {{.IPv4Address}}{{"\n"}}{{end}}')

	if [ -z "$newtwork_docker" ];then
		echo "Sin contenedores asociados"
	else
		echo "$network_docker"
	fi
	echo ""
done < <(docker network ls --format '{{.Name}}')
