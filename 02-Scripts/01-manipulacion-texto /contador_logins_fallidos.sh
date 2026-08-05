#!/bin/bash 
#Lee un archivo de texto con registros de acceso por línea (ejemplo: login_success, login_failed, login_failed). Procesa el archivo para registrar el total de inicios de sesión fallidos (login_failed) y muestra en pantalla el total detectado al finalizar.
STATIC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILE="$STATIC_DIR/datos_prueba/registros.txt"
echo "$STATIC_DIR"
CONT=0;
while read -r login; do 
   if [ -z "$login" ] || [[ "$login" =~ ^# ]];then
	continue	
   fi

   if [ "$login" == "login_failed" ]; then
	echo "[SALIDA STDERR] Se detecto un $login " >&2
	((CONT++));
   fi  

done < "$FILE"


echo "Total de inicio de sesion fallidos $CONT"
if [ "$CONT" -gt 3 ]; then  
        echo "[SALIDA STDERR] SE DETECTARON MÁS 3 INTENTOS DE INICIO DE SESIÓN" >&2
fi 
