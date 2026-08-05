#!/bin/bash 
#Lee un archivo de texto con registros de eventos del sistema por línea (ejemplo: INFO: Ok, ERROR: fallo de disco). Filtra y muestra por pantalla únicamente las líneas críticas (ERROR); si la línea corresponde a un evento informativo (INFO), envíala directamente a la salida de errores (2>).

while read -r eventos; do
   	if [ -z "$eventos" ] || [[ "$eventos" =~ ^# ]]; then
		continue
	fi
	
        if [[ "$eventos" =~ ^ERROR:  ]]; then
		echo "$eventos"
	elif [[ "$eventos" =~ ^INFO: ]]; then
		echo "$eventos" >&2
	fi
done < "log_eventos.txt" 
