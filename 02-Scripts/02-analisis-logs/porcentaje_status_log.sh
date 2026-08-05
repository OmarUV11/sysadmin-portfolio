#!/bin/bash 
#Crea un script que reciba un archivo de logs como argumen#to ($1). El script debe contar el total de peticiones #registradas, calcular cuántas respondieron con código de estado HTTP 200 (éxito) y cuántas con 404 (no encontrado), mostrando un resumen #porcentual simple.
set -euo pipefail

FILE_LOG="${1:-}"
DATE=$(date "+%Y%m%d")

if [ -z "$FILE_LOG" ]; then
	echo "La ruta que se coloco no contiene el archivo log" >&2
	exit 1
fi

if [ ! -f "$FILE_LOG" ]; then 
	echo "EL archivo no existe" >&2
	exit 1
fi 

TOTAL_PETICIONES=$(wc -l  "$FILE_LOG" | awk '{print $1}')
if [ "$TOTAL_PETICIONES" -eq 0 ]; then
	echo "El archivo esta vacio"
	exit 0
fi



CONT_PETICIONES_404=$(awk '$9=="404" {cont++} END {print cont+0}' "$FILE_LOG")
CONT_PETICIONES_200=$(awk '$9=="200" {cont++} END {print cont+0}' "$FILE_LOG")

PORC_200=$(awk -v c="$CONT_PETICIONES_200" -v t="$TOTAL_PETICIONES" 'BEGIN { printf "%.2f", (c/t)*100}')
PORC_404=$(awk -v c="$CONT_PETICIONES_404" -v t="$TOTAL_PETICIONES" 'BEGIN { printf "%.2f", (c/t)*100}')

REPORTE="reporte_log_"$DATE".log"
{
echo "------------------Resumen formateado ($DATE)---------------------" 
echo "Cantidad de peticiones 404: $CONT_PETICIONES_404"
echo "Porcentaje de peticiones 404: $PORC_404"
echo "------------------------------------------------------------------"
echo "Cantidad de peticiones 200: $CONT_PETICIONES_200" 
echo "Porcentaje de peticiones 200: $PORC_200"
echo "Total de peticiones: $TOTAL_PETICIONES"
} | tee -a "$REPORTE"

