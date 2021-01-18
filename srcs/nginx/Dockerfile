FROM    alpine:3.12
LABEL	maintainer Luca Robino <lrobino@student.42lyon.fr>

ARG     NGINX_ROOT="/var/www"

ENV     WWW_DOMAIN="localhost"
ENV     WWW_USER="www-data"
ENV     WWW_ROOT="${NGINX_ROOT}/${WWW_DOMAIN}/html"


# dependencies
RUN     apk --update --no-cache add bash openssl openssh

# openssh keygen
RUN     ssh-keygen -A

# openssl generation
RUN     openssl req -x509 -nodes \
        -days 365 \
        -subj "/C=FR/ST=69/O=Company, Inc./CN=${WWW_DOMAIN}" \
        -addext "subjectAltName=DNS:${WWW_DOMAIN}" \
        -newkey rsa:2048 \
        -keyout /etc/ssl/private/nginx-selfsigned.key \
        -out    /etc/ssl/certs/nginx-selfsigned.crt;


# add www user
RUN     adduser -D -g "${WWW_USER}" ${WWW_USER} && \
        mkdir -p ${WWW_ROOT} && \
        chmod -R 775 /home/${WWW_USER}


# nginx install
RUN     apk --update --no-cache add nginx && \
        mkdir -p /run/nginx && \
        chown -R ${WWW_USER}:${WWW_USER} /var/lib/nginx && \
        chown -R ${WWW_USER}:${WWW_USER} ${NGINX_ROOT} && \
        chown -R ${WWW_USER}:${WWW_USER} /run/nginx && \
        chmod -R 775 ${NGINX_ROOT}


# nginx copy config
COPY    ./config/localhost.conf /etc/nginx/sites-available/${WWW_DOMAIN}.conf
COPY    ./config/nginx.conf /etc/nginx/nginx.conf
# nginx copy default html
COPY    ./config/index.html ${WWW_ROOT}/index.html

# nginx enable server block in /etc/nginx/sites-available/
RUN     mkdir -p /etc/nginx/sites-enabled/ && \
        ln -s /etc/nginx/sites-available/${WWW_DOMAIN}.conf /etc/nginx/sites-enabled/ && \
        chown -R ${WWW_USER}:${WWW_USER} /etc/nginx/sites-enabled 

# nginx edit config
RUN     sed -i -e "s+WWW_ROOT+${WWW_ROOT}+g" -e "s+WWW_USER+${WWW_USER}+g" -e "s+WWW_DOMAIN+${WWW_DOMAIN}+g" /etc/nginx/nginx.conf && \
        sed -i -e "s+WWW_ROOT+${WWW_ROOT}+g" -e "s+WWW_DOMAIN+${WWW_DOMAIN}+g" /etc/nginx/sites-available/${WWW_DOMAIN}.conf

# nginx check config
RUN     nginx -t && \
        if [ "$?" -eq "1" ] ; then \
                exit 1 ; \
        fi


EXPOSE  80 443 22


CMD     /usr/sbin/sshd && nginx
