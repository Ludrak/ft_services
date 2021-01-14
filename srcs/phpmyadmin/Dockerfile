FROM alpine:latest

RUN apt-get update \
    && apt-get -y upgrade
RUN echo "--install Packages\n" \
    && apt-get -yq install  php php-common php-fpm php-mysql php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip \
    && mkdir /app

COPY srcs/. .

RUN echo "\nLaunching all services:\n" \
    && echo "- Install phpmyadmin" \
    && mv /phpMyAdmin-5.0.2-all-languages /usr/share/phpmyadmin \
    && echo "- Configure phpMyAdmin" \
    && ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin \
    && chown -R www-data:www-data /var/www/html/phpmyadmin \
    && mkdir -p /var/www/html/phpmyadmin/tmp \
    && chown -RH www-data:www-data /var/www/html/phpmyadmin/tmp \
    && sed -i "s~\$cfg\['blowfish_secret'\] = '';~\$cfg\['blowfish_secret'\] = 'STRINGOFTHIRTYTWORANDOMCHARACTERS';~g" /usr/share/phpmyadmin/config.inc.php

RUN echo "- configure SSL"\
    && openssl req -nodes -newkey rsa:2048 -sha256 -keyout /app/ssl/private.key -out /app/ssl/server.csr -subj "/C=FR/ST=69/L=Lyon/O=LECAILLE NATHAN/CN=Localhost" \
    && openssl x509 -req -days 365 -in /app/ssl/server.csr -signkey /app/ssl/private.key -out /app/ssl/server.crt \ 
    && nginx -t \
    && service nginx start \    
    && bash /app/MAJ_auto_index.sh 
