# 📌 Proyecto 1.1: Monitor de Salud y Alertas de Disco
  > Script automatizado en Bash para la supervision preventiva del almacenamiento en la particion raiz "/" del servidor y ejecucion de rutinas de rutinas de rendimiento de emergencia ante un umbral critico 

## 🏢 Contexto y Problema (Situación Laboral)
 * **Ticket / ID: ** #OPS-1042
 * **Entorno:** Servidor Linux (Debian / Ubuntu)
 * **Impacto:** Prevension de caidas de Infrestructura / Alta disponibilidad del Servidor 

El equipo de Monitoreo identificó un incidente en la particion (`/`) de un servidor en produccion alcanzandó su capacidad maxima provocando 
la interrupcion de servcios críticios y bases de datos. 

Para prevenir la falta de disponibilidad , se desarrolló e implementó el script `disk_cleaner.sh` una solucion en bash que evalua contantemente el almacenamiento, ejecuta acciones para remediar automaticamente el sobrepaso del umbral en el momento que se encuentre en estado critico de almacenamiento , todo esto siendo generado en un registro de auditoria estandarizado. 

## 🎯 Requerimientos Técnicos Cumplidos
* [x] **Aislamiento de Capacidad:** Extracción limpia del porcentaje de uso de la partición `/` procesado como un valor entero.
* [x] **Lógica Condicional:** Evaluación mediante umbral de disparo ($>= 85\%$).
* [x] **Rutinas de Remediación Automática:**
  * Depuración de paquetes huérfanos (`/usr/bin/apt autoremove -y`).
  * Limpieza de caché del gestor de paquetes (`/usr/bin/apt autoclean -y`).
  * Truncado a 0 bytes de archivos de registro antiguos (`.log`) con más de 30 días (`find` + `truncate`), liberando espacio sin destruir los descriptores de archivo del sistema.
* [x] **Protección de Seguridad:** Exclusión explícita del log de auditoría propio para evitar pérdida de registros.
* [x] **Manejo Eficiente de Procesos:** Procesamiento de logs mediante tuberías (`pipes`) directas en memoria, evitando el uso de archivos temporales en disco.
* [x] **Auditoría Centralizada:** Marcas de tiempo (*timestamps*) formateadas en texto plano guardadas en `/var/log/sysadmin_clean.log`.

## 📂 Estructura del Repositorio
```text
.
├── disk_cleaner.sh       # Script ejecutable principal en Bash
└── README.md             # Documentación técnica del proyecto

## ⚙️ Instalación y Permisos
1. Clonar el repositorio.
2. Asignar permisos (`chmod 700 disk_cleaner.sh`).

📍 AQUÍ VA EL CRONTAB 
## ⏰ Automatización con Cron (Crontab)
Explicación de cómo registrar la tarea con `sudo crontab -e`:
`0 1 * * * /bin/bash /home/csomar/proyectos_subir/1.1/disk_cleaner.sh`

## 🧪 Guía de Pruebas y Simulación
* Simulacion de archivo con 35 dias de antiguedad 
	
	touch -d "35 days ago" /tmp/archivo_antiguo_old.log
	echo "Generando lineas de prueba" > /tmp/archivo_antiguo_old.log

	#Ejucion del script
	sudo ./disk_cleaner.sh
	
	#Verificacion del truncado del archivo o 0 Bytes
	ls -l archivo_antiguo_old.log

## 📋 Registro de Auditoría (Logs)
*Si el uso de la particion '/' del sevidor es menor al umbral mostrara en el archivo .log 
----------------------------------------------------------------
[INFO-2026-08-10-11-41-29] El uso de la particion raiz del servidor es estable
----------------------------------------------------------------


*En el caso de la supere o sea igual al umbral mostrara lo siguiente: 
---------------------------------------------------------
[2026-08-10-11-49-22-ALERTA] USO DE LA PARTICION RAIZ ES CRITICO
--------------------------------------------------------
[2026-08-10-11-49-22-ALERTA] Ejecutando rutinas de emergencia
*[2026-08-10-11-49-22-INFO]Se eliminaron paquetes huerfanos*
*[2026-08-10-11-49-22-INFO]Se hizo una limpieza de cache*
[2026-08-10-11-49-22-INFO] El archivo log : /tmp/archivo_antiguo_old.log tiene mas de 30 dias
[2026-08-10-11-49-22-INFO] Se realizara la disminuacion de contenido al archivo: /tmp/archivo_antiguo_old.log 
[2026-08-10-11-49-22-CONFIRMACION] Se realizo la disminucion en los archivos
---------------------------------------------------------
[2026-08-10-11-50-06-ALERTA] USO DE LA PARTICION RAIZ ES CRITICO
--------------------------------------------------------
[2026-08-10-11-50-06-ALERTA] Ejecutando rutinas de emergencia
*[2026-08-10-11-50-06-INFO]Se eliminaron paquetes huerfanos*
*[2026-08-10-11-50-06-INFO]Se hizo una limpieza de cache*
[2026-08-10-11-50-06-INFO] El archivo log : /tmp/archivo_antiguo_old.log tiene mas de 30 dias
[2026-08-10-11-50-06-INFO] Se realizara la disminuacion de contenido al archivo: /tmp/archivo_antiguo_old.log 
[2026-08-10-11-50-06-CONFIRMACION] Se realizo la disminucion en los archivos

## 👤 Autor
Omar David Conde Suarez - Lic.Redes y Servicios de computo
