#!/bin/bash 
#!/bin/bash
# DESCRIPCIÓN: Construye una imagen personalizada de Docker desde un Dockerfile
#              y muestra en consola el ID y el tamaño de la imagen generada.
# USO:         ./docker_image_builder.sh <nombre_imagen:tag> <ruta_contexto> [build_arg]

NOMBRE_TAG="$1"
DIR_DOCKERFILE="$2"
ARG="$3"
if [ -z  "$NOMBRE_TAG" ] || [ -z "$DIR_DOCKERFILE" ]; then 
	echo "NO SE PASO ALGUNO DE LOS DOS ARGUMENTOS"
	exit 1 
fi


#Verificar si el directorio existe#
if [ ! -d "$DIR_DOCKERFILE" ]; then 
	echo "EL DIRECTORIO NO EXISTE"
	exit 1
fi

#VERIFICAR SI EXISTE EL EL ARCHIVO DOCKERFILE#

if [ ! -e "$DIR_DOCKERFILE/Dockerfile" ]; then 
	echo "EL DOCKERFILE NO EXISTE"
	exit 1 
fi 

#CONSTUIR IMAGENES#

if [ -z "$ARG" ]; then 

	docker build -t "$NOMBRE_TAG" "$DIR_DOCKERFILE" 
else 
	docker build -t "$NOMBRE_TAG" --build-arg "$ARG" "$DIR_DOCKERFILE"
fi

#Verificar la ultima imagen creada 
echo "====================================="
echo "INFORMACION DE LA IMAGEN "
echo "====================================="
docker images --format '{{.CreatedAt}}\t{{.Repository}}\t{{.Tag}} {{.ID}} {{.Size}}' | sort -r  | head -n 1

