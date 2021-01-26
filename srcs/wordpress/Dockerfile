FROM	nginx-base-image
LABEL	maintainer Luca Robino <lrobino@student.42lyon.fr>

ENV     WP_LOCALE="en_US"

#ARG     NGINX_ROOT="/var/www"

# ENV     WWW_DOMAIN="wordpress"
# ENV     WWW_USER="www-dataa"
# ENV     WWW_ROOT="${NGINX_ROOT}/${WWW_DOMAIN}/html"

ENV     PHP_VERSION="7"

# dependencies
RUN     apk --update --no-cache add bash openssl wget bind-tools


# openssl generation
RUN     openssl req -x509 -nodes \
        -days 365 \
        -subj "/C=FR/ST=69/O=Company, Inc./CN=${WWW_DOMAIN}" \
        -addext "subjectAltName=DNS:${WWW_DOMAIN}" \
        -newkey rsa:2048 \
        -keyout /etc/ssl/private/nginx-selfsigned.key \
        -out /etc/ssl/certs/nginx-selfsigned.crt;


# php install
RUN     apk --update --no-cache add \
        php${PHP_VERSION} \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-json \
        php${PHP_VERSION}-zlib \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-pdo \
        php${PHP_VERSION}-phar \
        php${PHP_VERSION}-openssl \
        php${PHP_VERSION}-pdo_mysql \
        php${PHP_VERSION}-mysqli \
        php${PHP_VERSION}-mysqlnd \
        php${PHP_VERSION}-gd \
        php${PHP_VERSION}-mcrypt \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-opcache \
        php${PHP_VERSION}-ctype \
        php${PHP_VERSION}-intl \
        php${PHP_VERSION}-bcmath \
        php${PHP_VERSION}-dom \
        php${PHP_VERSION}-xmlreader \
        php${PHP_VERSION}-tokenizer \
        php${PHP_VERSION}-iconv \
        php${PHP_VERSION}-exif \
        php${PHP_VERSION}-fileinfo \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-pecl-imagick \
        php${PHP_VERSION}-zip


# php-fpm config
COPY    ./config/php/www.conf /etc/php${PHP_VERSION}/php-fpm.d/www.conf
COPY    ./config/php/php-fpm.conf /etc/php${PHP_VERSION}/php-fpm.conf
RUN     sed -i /etc/php7/php-fpm.d/www.conf\
	-e "s+WWW_USER+${WWW_USER}+g" \
	-e "s+WWW_DOMAIN+${WWW_DOMAIN}+g" \
	-e "s+WWW_ROOT+${WWW_ROOT}+g" && \
        sed -i /etc/php7/php-fpm.conf \
	-e "s+WWW_USER+${WWW_USER}+g" \
	-e "s+WWW_DOMAIN+${WWW_DOMAIN}+g" \
	-e "s+WWW_ROOT+${WWW_ROOT}+g"

# nginx copy config
COPY    ./config/nginx/localhost.conf /etc/nginx/sites-available/${WWW_DOMAIN}.conf
COPY    ./config/nginx/nginx.conf /etc/nginx/nginx.conf
# nginx copy default html
COPY    ./config/nginx/index.html ${WWW_ROOT}/index.html

# nginx edit config
RUN      sed -i /etc/nginx/nginx.conf \
	-e "s+WWW_USER+${WWW_USER}+g" \
	-e "s+WWW_DOMAIN+${WWW_DOMAIN}+g" \
	-e "s+WWW_ROOT+${WWW_ROOT}+g" && \
        sed -i /etc/nginx/sites-available/${WWW_DOMAIN}.conf \
	-e "s+WWW_USER+${WWW_USER}+g" \
	-e "s+WWW_DOMAIN+${WWW_DOMAIN}+g" \
	-e "s+WWW_ROOT+${WWW_ROOT}+g"

# nginx check config
RUN     nginx -t && \
        if [ "$?" -eq "1" ] ; then \
                exit 1 ; \
        fi


# wpcli install
RUN     wget -qO /usr/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
        wget https://wordpress.org/latest.tar.gz -P /tmp && \
        wget -O /tmp/wp_key.txt https://api.wordpress.org/secret-key/1.1/salt/ && \
        chmod +x /usr/bin/wp

# wordpress install
RUN     wp --path=${WWW_ROOT} core download --locale=${WP_LOCALE}

# configure wordpress
COPY    config/wordpress/wp-config.php  ${WWW_ROOT}/wp-config.php
COPY    config/wordpress/startwp.sh     /scripts/

RUN     chmod -R 755 ${WWW_ROOT} && \
        chown -R ${WWW_USER}:${WWW_USER} ${WWW_ROOT} && \
        sed -i -e "/^define( 'AUTH_KEY',         'put your unique phrase here' );/r /tmp/wp_key.txt" -e "/^define( 'AUTH_KEY',         'put your unique phrase here' );/,/^define( 'NONCE_SALT',       'put your unique phrase here' );/d" ${WWW_ROOT}/wp-config.php



EXPOSE  5050


ENTRYPOINT ["/bin/bash", "/scripts/startwp.sh"]