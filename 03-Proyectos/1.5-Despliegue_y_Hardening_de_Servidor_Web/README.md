# 📌 Proyecto 1.5: Despliegue y Hardening de Servidor Web Seguro
	> Bastionado de seguridad en servidor Linux para entorno de pruebas (staging): hardening de SSH, políticas restrictivas en cortafuegos (UFW), ocultamiento de firmas en Nginx y generación de evidencias para auditoría de SecOps.
## 🏢 Contexto y Problema (Situación Laboral)
 	El equipo de Seguridad de la Información (SecOps) ha emitido una directiva obligatoria: todo servidor web interno en el entorno de pruebas (staging) debe contar con una capa de hardening (bastionado) antes de pasar a auditoría. Como Administrador de Sistemas, debes tomar la base del servidor web ya desplegado, aplicar políticas de seguridad en el sistema operativo, restringir accesos, asegurar el servicio web y presentar las evidencias de auditoría para el cierre del ticket.

## 🎯 Requerimientos Técnicos Cumplidos
* [x] **Bastionado de SSH** 
* [x] **Configuracion de red y fiewall**
* [x] **Seguridad del Servidor Web (Nginx)**
* [X] **Validacion de Seguridad y Auditorias**
 

## 📂 Estructura del Repositorio
```text
.
└── README.md             # Documentación técnica del proyecto

## ⚙️ Instalación , Configuracion y Permisos
1. Clonar el repositorio.
2. Abrir README.md
3. Desabilitacion del inicios de sesion inseguros, para ello se debe de editar el archivo sshd_config
   dentro del archivo se debe de agregar o desmarcar las siguientes lineas:

	PermitRootLogin no ; Esta linea deniega la autenticacion del usuario root del sistema linux 
	PasswordAuthentication no; desactiva la auntenticacion por contraseña y solo se utilizaran llaves publicas o privadas  

4.Configuracion del Corta Fuegos UFW
 

	#Limitacion de puertos solo para el servicio de ssh y nginx 
	sudo ufw allow 80/tcp comment "Servicio Web"
	sudo ufw allow 443/tcp comment "Servicio Web"

	#Puerto del ssh 
	Como otra manera de seguridad tambien se cambio  el puerto por defecto de 22 a 3000 para evitar ataques 
	Configuracion de ufw para ssh
	 
		sudo ufw allow 3000/tcp comment "Servicio SSH"
	
	#Cerrado de trafico no autorizado 
		sudo ufw default deny incoming  #deniega todas la conexiones entrantes
		sudo ufw default allow outgoing #acepta todas las conexiones salientes

	#Cargamos la configuracion 
		sudo ufw reload 

5-.Ocultar encabezados de version del servidor (server_tokens off;) para prevenir conocimientos de firmas 

	#Se debe de editar el archivo de configuracion ngix.conf que esta en la carpeta etc, si viene marcada la opcion 
	# server_tokes off; solo se tiene que desmarcar 
	
	
## 📋 Registro de Auditorías:
1.Verificacion de la configuracion de ssh 
	"sudo grep -E "^(PermitRootLogin|PasswordAuthentication)" /etc/ssh/sshd_config

	#Salida del comando 
	PermitRootLogin no 
	PasswordAuthentication no

2-.Salide de la configuracion de acceso del ufw mediante el comando ufw status verborse
	#Para la configuracion de trafico entrante y saliente se utilizaron el comando ufw default denny incoming para el entrante y para el saliente ufw default allow outgoing#
	
	sudo ufw status 
Status: active

To                         Action      From
--                         ------      ----
80                         ALLOW       Anywhere                   # Servicio Web HTTP
443                        ALLOW       Anywhere                   # Servicio Web HTTPS
3000/tcp                   ALLOW       Anywhere                   # Serivicio SSH
80 (v6)                    ALLOW       Anywhere (v6)              # Servicio Web HTTP
443 (v6)                   ALLOW       Anywhere (v6)              # Servicio Web HTTPS
3000/tcp (v6)              ALLOW       Anywhere (v6)              # Serivicio SSH

3-.Verificacion de enbezados HTTP
curl -I http://localhost
HTTP/1.1 200 OK
Server: nginx
Date: Fri, 14 Aug 2026 22:48:03 GMT
Content-Type: text/html
Content-Length: 307
Last-Modified: Fri, 14 Aug 2026 22:37:25 GMT
Connection: keep-alive
ETag: "6a7f98a5-133"
Accept-Ranges: bytes

4-.Inspeccion de Sockets activos
	ss -tulpn
Netid  State   Recv-Q  Send-Q                        Local Address:Port     Peer Address:Port  Process                                   
udp    UNCONN  0       0                                   0.0.0.0:43181         0.0.0.0:*                                               
udp    UNCONN  0       0                                   0.0.0.0:5353          0.0.0.0:*      users:(("firefox-esr",pid=5025,fd=236))  
udp    UNCONN  0       0                                   0.0.0.0:5353          0.0.0.0:*                                               
udp    UNCONN  0       0                                         *:51268               *:*      users:(("firefox-esr",pid=5025,fd=142))  
udp    UNCONN  0       0                                         *:36921               *:*      users:(("firefox-esr",pid=5025,fd=44))   
udp    UNCONN  0       0                                         *:45657               *:*      users:(("firefox-esr",pid=5025,fd=118))  
udp    UNCONN  0       0                                      [::]:54365            [::]:*                                               
udp    UNCONN  0       0                                      [::]:5353             [::]:*                                               
udp    UNCONN  0       0                                         *:56388               *:*      users:(("firefox-esr",pid=5025,fd=80))   
udp    UNCONN  0       0        [fe80::62e9:aaff:fe5b:4d01]%wlp1s0:546              [::]:*                                               
tcp    LISTEN  0       511                                 0.0.0.0:80            0.0.0.0:*                                               
tcp    LISTEN  0       128                            192.168.1.77:3000          0.0.0.0:*                                               
tcp    LISTEN  0       4096                              127.0.0.1:631           0.0.0.0:*                                               
tcp    LISTEN  0       511                                    [::]:80               [::]:*                                               
tcp    LISTEN  0       4096                                  [::1]:631              [::]:*   

5-.Inspeccion de los logs de acceso y errores servidor web

sudo tail -n 10 /var/log/nginx/access.log
127.0.0.1 - - [17/Aug/2026:15:14:25 -0600] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0"
127.0.0.1 - - [17/Aug/2026:15:14:25 -0600] "GET /favicon.ico HTTP/1.1" 404 118 "http://localhost/" "Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0"
::1 - - [17/Aug/2026:15:25:07 -0600] "HEAD / HTTP/1.1" 200 0 "-" "curl/8.14.1"

sudo tail -n 10 /var/log/nginx/error.log 
sin errores registrados

## 👤 Autor
Omar David Conde Suarez - Lic.Redes y Servicios de computo
