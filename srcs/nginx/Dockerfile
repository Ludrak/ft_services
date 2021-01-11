FROM	alpine
LABEL	maintainer Luca Robino <lrobino@student.42lyon.fr>

ARG     NGINX_ROOT="/var/www"

ENV     WWW_DOMAIN="localhost"

ENV     WWW_USER="www-data"
ENV     WWW_ROOT="${NGINX_ROOT}/${WWW_DOMAIN}"

# dependencies
RUN     apk --update --no-cache add bash

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
#COPY    ./config/domain.conf /etc/nginx/sites-enabled/${WWW_DOMAIN}
COPY    ./config/nginx.conf /etc/nginx/nginx.conf
# nginx copy default html
COPY    ./config/index.html ${WWW_ROOT}/index.html

# nginx edit config
RUN     sed -i -e "s+WWW_ROOT+${WWW_ROOT}+g" -e "s+WWW_USER+${WWW_USER}+g" -e "s+WWW_DOMAIN+${WWW_DOMAIN}+g" /etc/nginx/nginx.conf
#       sed -i -e "s+WWW_ROOT+${WWW_ROOT}+g" -e "s+WWW_DOMAIN+${WWW_DOMAIN}+g" /etc/nginx/sites-enabled/${WWW_DOMAIN}

EXPOSE  80

CMD     nginx