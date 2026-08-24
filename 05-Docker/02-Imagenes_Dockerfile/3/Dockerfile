FROM debian 
RUN apt-get update -y && apt-get install -y apache2 && apt-get clean && rm -rf /var/lib/apt/lists/*
ADD ./public_html /var/www/html/
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
