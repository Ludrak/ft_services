FROM	nginx-base-image

LABEL	maintainer Luca Robino <lrobino@student.42lyon.fr>

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
