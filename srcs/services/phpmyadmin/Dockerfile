FROM    nginx-base-image

LABEL	maintainer Nathan Lecaille <nlecaill@student.42lyon.fr>

# update system
RUN apk update

# ARG     NGINX_ROOT="/var/www"

# ENV     WWW_DOMAIN="phpmyadmin"
# ENV     WWW_USER="www-data"
# ENV     WWW_ROOT="${NGINX_ROOT}/html"
# ENV     WWW_ROOT="${NGINX_ROOT}/${WWW_DOMAIN}/html"

ENV     PHP_VERSION="7"
ENV     PMA_LOCATION="/usr/share/phpMyAdmin/"
ARG     PMA_VERSION="phpMyAdmin-5.0.4-all-languages"

# php install
RUN     apk --update --no-cache add \
        php${PHP_VERSION} \
        php${PHP_VERSION}-fpm \
        php${PHP_VERSION}-json \
        php${PHP_VERSION}-zlib \
        php${PHP_VERSION}-session \
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
# TODO check if nginx.conf is modified since nginx-base.conf
 
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

COPY config/${PMA_VERSION}.zip ${PMA_LOCATION}

WORKDIR ${PMA_LOCATION}

COPY config/php/config.inc.php  .
COPY config/php/setupPma.sh       /

RUN echo "- Install phpmyadmin" \
    && unzip ${PMA_VERSION}.zip -d . 2>&1 > /dev/null \
    && mv ${PMA_VERSION}/* . \
    && rmdir ${PMA_VERSION} \
    && rm ${PMA_VERSION}.zip \
    && ln -s ${PMA_LOCATION} ${WWW_ROOT}/phpmyadmin \
    && chown -R www-data:www-data ${WWW_ROOT}/phpmyadmin \
    && mkdir -p ${WWW_ROOT}/phpmyadmin/tmp \
    && chown -RH www-data:www-data ${WWW_ROOT}/phpmyadmin/tmp \
    && chmod +x /setupPma.sh

# install telegraf

RUN apk add libc6-compat gcompat \ 
        && wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz

RUN     tar xf telegraf-1.15.2_linux_amd64.tar.gz -C / \
        && rm telegraf-1.15.2_linux_amd64.tar.gz

COPY    config/telegraf/telegraf.conf /etc/telegraf/

EXPOSE  5000

WORKDIR /

COPY    config/validity.sh    /

ENTRYPOINT [ "/bin/bash", "/setupPma.sh" ]
