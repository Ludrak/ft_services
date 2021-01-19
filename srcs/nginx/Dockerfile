FROM	nginx-base-image

LABEL	maintainer Luca Robino <lrobino@student.42lyon.fr>

ARG     NGINX_ROOT="/var/www"

ENV     WWW_DOMAIN="localhost"
ENV     WWW_USER="www-data"
ENV     WWW_ROOT="${NGINX_ROOT}/${WWW_DOMAIN}/html"

# nginx copy config
COPY    ./config/localhost.conf /etc/nginx/sites-available/${WWW_DOMAIN}.conf
# nginx copy default html
COPY    ./config/index.html ${WWW_ROOT}/index.html

# nginx edit config
RUN     sed -i -e "s+WWW_ROOT+${WWW_ROOT}+g" -e "s+WWW_USER+${WWW_USER}+g" -e "s+WWW_DOMAIN+${WWW_DOMAIN}+g" /etc/nginx/nginx.conf && \
        sed -i -e "s+WWW_ROOT+${WWW_ROOT}+g" -e "s+WWW_DOMAIN+${WWW_DOMAIN}+g" /etc/nginx/sites-available/${WWW_DOMAIN}.conf

# nginx check config
RUN     nginx -t && \
        if [ "$?" -eq "1" ] ; then \
                exit 1 ; \
        fi

CMD     /usr/sbin/sshd && nginx
