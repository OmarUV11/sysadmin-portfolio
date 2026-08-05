#!/bin/bash
# DESCRIPCIÓN:  Menú interactivo para diagnosticar conectividad, IP local
#               y puertos escuchando en el sistema.
set -euo pipefail
CONTINUAR=1
while [ $CONTINUAR -eq 1 ]; do
	clear
	echo "*******************************"
	echo   "Menu de opciones"
	echo   "1.Mostar IP local"
	echo   "2.Ping rapido a 8.8.8.8"
	echo   "3.Mostrar puertos en escucha"
	echo   "4.Salir"
	echo "*******************************"
	read -rp "Selecciona un opcion: " OPCION

	case $OPCION in 
		1)
			echo "-------------------------------------------------------"
			echo "Esta es la IP local: "$(hostname -I | awk '{print $1}')
			echo "-------------------------------------------------------"
			read -rp "Seleccione una opcion:" OPCION
			sleep 2
			;;
	
		2)
			echo "-----------------------------"
			echo "Realizando un ping a 8.8.8.8"
			echo "-----------------------------"
			ping -c 5 8.8.8.8 || echo "[ERROR] Sin respuesta del host."
			read -rp "Presiona enter para continuar...."
			;;

		3)
			echo "---------------------------------"
			echo "Estos son los puertos escuchando"
			echo "---------------------------------"
			ss -tulpn 2>/dev/null || ss -tuln
			read -rp "Presione enter para continuar"
			sleep 2
			;;

		4)	
			echo "---------------------"
			echo "Saliendo del Menu...."
			echo "---------------------"
			sleep 2
			exit 0
			;;
		*)
			echo "Opcion no valida."
			sleep 1
		;;
		

	esac
done
