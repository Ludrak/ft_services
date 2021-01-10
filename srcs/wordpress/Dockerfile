FROM	alpine
LABEL	maintainer Luca Robino <lrobino@student.42lyon.fr>

ARG     WP_LOCALE="en_US"

ARG     WWW_USER="www-data"
ARG     NGINX_ROOT="/var/www"
ARG     WEB_ROOT="${NGINX_ROOT}/wordpress"

ARG     PHP_VERSION="7"
ARG     WPCLI_VERSION="1.5.1"

ENV PHP_FPM_LISTEN_MODE="0660"
ENV PHP_MEMORY_LIMIT="512M"
ENV PHP_MAX_UPLOAD="50M"
ENV PHP_MAX_FILE_UPLOAD="200"
ENV PHP_MAX_POST="100M"
ENV PHP_DISPLAY_ERRORS="On"
ENV PHP_DISPLAY_STARTUP_ERRORS="On"
ENV PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"
ENV PHP_CGI_FIX_PATHINFO=0

ADD     https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

# installing dependencies
RUN     apk --update --no-cache add \
        bash \
        curl \
        freetype-dev \
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
RUN     sed -i /etc/php7/php-fpm.d/www.conf\
	-e "s|;listen.owner\s*=\s*nobody|listen.owner = ${WWW_USER}|g"\
	-e "s|;listen.group\s*=\s*nobody|listen.group = ${WWW_USER}|g"\
        -e "s|;listen.mode\s*=\s*0660|listen.mode = 0660|g"\
	-e "s|user\s*=\s*nobody|user = ${WWW_USER}|g"\
	-e "s|group\s*=\s*nobody|group = ${WWW_USER}|g"\
	-e "s|;log_level\s*=\s*notice|log_level = notice|g"\
	/etc/php7/php-fpm.d/www.conf

# nginx install
RUN     apk --update --no-cache add nginx && \
        mkdir -p /run/nginx/ 

# add WWW user
RUN     adduser -D -G${WWW_USER} ${WWW_USER} && \
	chown -R ${WWW_USER}:${WWW_USER} /var/lib/nginx && \
        chmod -R 775 /home/${WWW_USER}

# nginx config
RUN     mkdir -p /etc/nginx/old-conf/ && \
        mv /etc/nginx/nginx.conf /etc/nginx/old-conf/nginx.conf.origin
COPY    ./config/nginx/index.html ${WEB_ROOT}/index.html
COPY    ./config/nginx/wordpress.conf /etc/nginx/sites-enabled/wordpress.conf
COPY    ./config/nginx/nginx.conf /etc/nginx/nginx.conf
RUN     mkdir -p ${WEB_ROOT} && \
        sed -i "s+WEB_ROOT+${WEB_ROOT}+g" /etc/nginx/nginx.conf && \
        sed -i "s/USER_WWW/${WWW_USER}/g" /etc/nginx/nginx.conf && \
        sed -i "s+root /var/www/html+root ${WEB_ROOT}+g" /etc/nginx/sites-enabled/wordpress.conf && \
        chmod -R 755 ${NGINX_ROOT} && \
        chown -R ${WWW_USER}:${WWW_USER} ${NGINX_ROOT}

# wpcli install
RUN     wget -qO /usr/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
        chmod +x /usr/bin/wp

# wordpress install
RUN     wp --path=${WEB_ROOT} core download --locale=${WP_LOCALE} && \
	cp ${WEB_ROOT}/wp-config-sample.php ${WEB_ROOT}/wp-config.php && \
        chmod -R 755 ${WEB_ROOT} && \
        chown -R ${WWW_USER}:${WWW_USER} ${WEB_ROOT}

EXPOSE  5050

CMD     php-fpm7 -DR && nginx -g "daemon off;"
