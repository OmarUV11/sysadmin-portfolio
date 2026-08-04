#!/bin/bash 
UMBRAL=80
DISCO_USO=$(df  / | awk 'NR>1 {print $5}' | tr -d '%' )
if [ $DISCO_USO -ge $UMBRAL ]; then 
	echo "[ALERTA] el uso del disco supero o alcanzo el limite permitido ($DISCO_USO%)"
else
	echo "[OK] el porcentaje se encuentra por debajo del umbral ($DISCO_USO%)"
fi
