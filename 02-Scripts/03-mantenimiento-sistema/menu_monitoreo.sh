#!/bin/bash 
# DESCRIPCIÓN:  Menú interactivo en consola para verificar métricas clave del 
#               sistema (espacio en disco, memoria RAM y usuarios activos).
INICIADOR=1
limpiar_y_pausa(){
	echo ""
	echo "Presione una tecla para continuar.."
	read -rn 1
	clear
}

while true; do
	echo "1.Ver espacio en disco"
	echo "2.Ver uso de la memoria ram"
	echo "3.Ver usuarios conectados"
	echo "4.Salir"
	read -p "Seleccionar opcion: " OPCION
	case $OPCION in 
		1)
			echo "------------------"
			echo "Estado del disco:"
			echo "------------------"
			df -h
			limpiar_y_pausa
		;;
		2)
			echo "-------------------"
			echo "Uso de memoria ram:"
			echo "-------------------"
			free -h
			limpiar_y_pausa
		;;
		3)	
			echo "--------------------"
			echo "Usuarios contectados"
			echo "--------------------"
			who -u
			limpiar_y_pausa	

		;;
		4)
			echo "-----------------"
			echo "Saliendo del menu"
			echo "-----------------"
			sleep 1
			clear
			exit 0
		;; 
		*)
			echo "Opcion no valida"
			sleep 2
			clear
			
                        
		;;
	esac
done
