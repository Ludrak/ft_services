FROM	nginx-base-image

LABEL	maintainer Luca Robino <lrobino@student.42lyon.fr>
LABEL	maintainer Lecaille Nathan <nlecaill@student.42lyon.fr>

# nginx copy config
COPY    ./config/localhost.conf /etc/nginx/sites-available/${WWW_DOMAIN}.conf
# nginx copy default html
COPY    ./config/website    ${WWW_ROOT}/website

RUN     mv ${WWW_ROOT}/website/* ${WWW_ROOT}/ && rm -rf ${WWW_ROOT}/website
# nginx edit config
RUN     sed -i -e "s+WWW_ROOT+${WWW_ROOT}+g" -e "s+WWW_USER+${WWW_USER}+g" -e "s+WWW_DOMAIN+${WWW_DOMAIN}+g" /etc/nginx/nginx.conf && \
        sed -i -e "s+WWW_ROOT+${WWW_ROOT}+g" -e "s+WWW_DOMAIN+${WWW_DOMAIN}+g" /etc/nginx/sites-available/${WWW_DOMAIN}.conf

# nginx check config
RUN     nginx -t && \
        if [ "$?" -eq "1" ] ; then \
                exit 1 ; \
        fi
# install telegraf
RUN     apk add libc6-compat gcompat \ 
        && wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz

RUN     tar xf telegraf-1.15.2_linux_amd64.tar.gz -C / \
        && rm telegraf-1.15.2_linux_amd64.tar.gz

COPY    config/telegraf/telegraf.conf /etc/telegraf/ 

COPY    config/setupNgx.sh      /
COPY    config/validity.sh      /

ENTRYPOINT [ "/bin/bash", "setupNgx.sh" ]
