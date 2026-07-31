#!/bin/bash
STATIC_RUTE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATE=$(/usr/bin/date '+%Y-%m-%d %H-%M')
UMBRAL=85
PORCENTAJE_RAM=$(free | awk '/Mem:/ {print int($3/$2*100)}');

if [ "$PORCENTAJE_RAM" -ge "$UMBRAL" ]; then 
	echo "EL uso de memoria ram supera el umbral $UMBRAL% $DATE" | tee -a "$STATIC_RUTE/alerta_sistema.log" 
fi
