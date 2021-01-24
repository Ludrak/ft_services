FROM	alpine:3.12
LABEL	maintainer Mulham Soufi <musoufi@student.42lyon.fr>

ARG     NGINX_ROOT="/var/www"

ENV     WWW_DOMAIN="ftps"
ENV     WWW_USER="www-data"
ENV     WWW_ROOT="${NGINX_ROOT}/html"

ENV     FTP_USER="admin"
ENV     FTP_PASSWORD="admin"

COPY    vsftpd.conf ./etc/vsftpd/
COPY    start.sh ./

# dependencies
RUN     apk --update --no-cache add bash openssl vsftpd

# user
RUN     mkdir -p /etc/ftps/${FTP_USER} && \
	    adduser --home=/etc/ftps/${FTP_USER} -D ${FTP_USER} && \
	    echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd

# vsftpd user
RUN     echo "${FTP_USER}" >> /etc/vsftpd/vsftpd.userlist

# openssl generation
RUN     openssl req -x509 -nodes \
        -days 365 \
        -subj "/C=FR/ST=69/O=Company, Inc./CN=${WWW_DOMAIN}" \
        -addext "subjectAltName=DNS:${WWW_DOMAIN}" \
        -newkey rsa:2048 \
        -keyout /etc/ssl/private/vsftpd.key \
        -out    /etc/ssl/certs/vsftpd.crt;

EXPOSE  20 21 21009-21011

RUN     chmod +x start.sh

CMD["sleep", "infinity"]