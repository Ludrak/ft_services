FROM	alpine:3.12

LABEL	maintainer Mulham Soufi <musoufi@student.42lyon.fr>
LABEL   maintainer Luca Robino <lrobino@student.42lyon.fr>
 
ENV     FTP_USER="admin"
ARG     FTP_PASSWORD="admin"
ARG     ROOT_PASSWORD="toor"

ENV     FTP_MIN_PORT="21000"
ENV     FTP_MAX_PORT="21010"

ENV     FTP_CONF="/etc/vsftpd/vsftpd.conf"
ENV     FTP_USERLIST="/etc/vsftpd/vsftpd.userlist"

ENV     SSL_CERT="/etc/ssl/certs/tls.crt"
ENV     SSL_KEY="/etc/ssl/private/tls.key"

# dependencies
RUN     apk --update --no-cache add bash curl wget jq openrc openssl vsftpd && \
        mkdir -p /run/openrc && \
        touch /run/openrc/softlevelm

# add ftp user
RUN     adduser -D -g "${FTP_USER}" ${FTP_USER} && \
        mkdir -p /home/${FTP_USER} && \
        echo "root:${ROOT_PASSWORD}" | chpasswd && \
        echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd && \
        echo "${FTP_USER}" >> ${FTP_USERLIST}

# install telegraf
RUN     apk add libc6-compat gcompat \
        && wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz

RUN     tar xf telegraf-1.15.2_linux_amd64.tar.gz -C / \
        && rm telegraf-1.15.2_linux_amd64.tar.gz

RUN    cd /etc/ && mkdir telegraf; cd /

COPY    config/telegraf/telegraf.conf /etc/telegraf

# config vsftpd
COPY    config/vsftpd.conf ${FTP_CONF}

# copy init
COPY    entrypoint.sh /entrypoint.sh
RUN     chmod a+x /entrypoint.sh

COPY    config/validity.sh      /

EXPOSE  20 21 ${FTP_MIN_PORT}-${FTP_MAX_PORT}

ENTRYPOINT [ "/entrypoint.sh" ]
