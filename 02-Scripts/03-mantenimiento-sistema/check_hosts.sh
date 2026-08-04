#!/bin/bash 
STATIC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
FILE="$STATIC_DIR/datos_prueba_mantenimiento/hosts.txt"
if [ ! -f "$FILE" ]; then 
        echo "EL archivo no existe" >&2
        exit 1
fi


while read -r hosts ; do 
        ping -c 1 -W 2 "$hosts" > /dev/null
        if [ $? -eq 0 ];then
                echo "[ONLINE] $hosts"
        else 

                echo "[OFFILE] $hosts"
        fi
done < "$FILE"
