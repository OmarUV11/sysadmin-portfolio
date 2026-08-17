 # 📌 Proyecto 1.4: Despliegue e Integración de Servidor Web Corporativo

    > Instalación y configuración de un servicio web Nginx, para poder mejorar el entorno de pruebas,se debe de desplegar el servicio y configurar reglas de acceso en cortafuegos , verificar disponbilidad del sistema

## 🏢 Contexto y Problema (Situación Laboral)

     Se requiere de un servicio web para poder establecer un entorno de pruebas.Como administrador de sistema se debe de establecer la configuraciones pertinentes del servicio, configurar reglas de acceso en el cortafuegos ,verificar la disponibilidad del sistema y generar la evidencia de auditorias para poder cerrar el ticket de soporte 


## 🎯 Requerimientos Técnicos Cumplidos

* [x] **Instalación del paquete que tiene el servicio web (nginx), habilitar el servicio nginx para mejor persistencia** 

* [x] **Configuración de cortafuegos para el trafico de red en los puertos 80 y 443 (hardening)**

* [x] **Comprobar un punto de prueba de estado o una pagina para verificar el estado del servicio, en la raiz del servicio web**

* [X] **Validar funcionamiento del servidor web mediante sockets de red y respuestas http del servicio**

 


## 📂 Estructura del Repositorio

```text

.

└── README.md             # Documentación técnica del proyecto


## ⚙️ Instalación y Permisos

1. Clonar el repositorio.

2. Instalar el paquete web que tiene nginx -  apt update && apt-get install nginx -y.

3. Habilitar servicio web, para mejorar persistencia - systemctl enable nginx 

4. Configuración de ufw(cortafuegos) para permitir peticiones por el puerto 80 o http y 443 o https. 

   ufw allow 80 comment "Solicitudes HTTP"

   ufw allow 443 comment "Solicitudes HTTPS"

   ufw reload (Recargar configuración del cortafuegos)

   ufw status verbose (verificacion del estado del cortafuegos)

5.Remplazar archivo index.html que viene por defecto en /var/www/html/

  sudo bash -c 'cat <<EOF > /var/www/html/index.html

      <!DOCTYPE html>

    <html lang="es">

        <head>

                <meta charset="UTF-8">

                <title>Internal Staging Server</title>

        </head>

        <body>

                <h1>Servidor de Pruebas Corporativo</h1>

                <p>Estado del Servicio: <strong>ONLINE</strong></p>

                <p>Infraestructura gestionada por el Equipo de SysAdmin.</p>

        </body>

    </html>

EOF'


6-.Ejecutar una comprobacion del socket 80/tcp en la interfaz local 

ss -tulpn | grep :80

tcp   LISTEN 0      511                               0.0.0.0:80         0.0.0.0:*          

tcp   LISTEN 0      511               

          

7-.Realizar peticion http local sobre el servidor para obtener el encabezado de respuesta 

curl -I http://localhost


8-.Consultar logs del servidor web 

tail -f /var/log/nginx/access.log 



## 📋 Registro de Auditorías:

1.Estado del serivicio web nginx 

    sudo systemctl is-active nginx.service 

    (Salida del comando) active


2-.Configuracion del Firewall con las reglas de acceso para el puerto 443 y 80 

    sudo ufw status verbose 

    Status: active

    Logging: on (low)

    Default: deny (incoming), allow (outgoing), deny (routed)

    New profiles: skip


    To                         Action      From

    --                         ------      ----

    80                         ALLOW IN    Anywhere                   # Servicio Web HTTP

    443                        ALLOW IN    Anywhere                   # Servicio Web HTTPS

    80 (v6)                    ALLOW IN    Anywhere (v6)              # Servicio Web HTTP

    443 (v6)                   ALLOW IN    Anywhere (v6)              # Servicio Web HTTPS


3-.Comprobacion de logs del serivicio web y mediante solicitudes curl hacia localhost

curl  http://localhost

<!DOCTYPE html> (RESPUESTA)

<html lang="es">

<head>

    <meta charset="UTF-8">

    <title>Internal Staging Server</title>

</head>

<body>

    <h1>Servidor de Pruebas Corporativo</h1>

    <p>Estado del Servicio: <strong>ONLINE</strong></p>

    <p>Infraestructura gestionada por el Equipo de SysAdmin.</p>

</body>

</html>



4-.curl -I http://localhost

HTTP/1.1 200 OK

Server: nginx

Date: Fri, 14 Aug 2026 22:48:03 GMT

Content-Type: text/html

Content-Length: 307

Last-Modified: Fri, 14 Aug 2026 22:37:25 GMT

Connection: keep-alive

ETag: "6a7f98a5-133"

Accept-Ranges: bytes


LOG DEL SERVIDOR 


5-.sudo tail -n 10 -f /var/log/nginx/access.log

127.0.0.1 - - [13/Aug/2026:09:00:06 -0600] "GET / HTTP/1.1" 200 58 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0"

127.0.0.1 - - [13/Aug/2026:09:00:07 -0600] "GET /favicon.ico HTTP/1.1" 404 118 "http://localhost/" "Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0"

::1 - - [14/Aug/2026:16:42:49 -0600] "HEAD / HTTP/1.1" 200 0 "-" "curl/8.14.1"

127.0.0.1 - - [14/Aug/2026:16:43:04 -0600] "GET / HTTP/1.1" 200 245 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0"

127.0.0.1 - - [14/Aug/2026:16:43:04 -0600] "GET /favicon.ico HTTP/1.1" 404 118 "http://localhost/" "Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0"

::1 - - [14/Aug/2026:16:45:08 -0600] "GET / HTTP/1.1" 200 307 "-" "curl/8.14.1"

127.0.0.1 - - [14/Aug/2026:16:47:02 -0600] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0"


## 👤 Autor

Omar David Conde Suarez - Lic.Redes y Servicios de computo 
