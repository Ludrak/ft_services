FROM	alpine:3.12
LABEL	maintainer Luca Robino <lrobino@student.42lyon.fr>

# mysql db info
ENV     MYSQL_DATADIR="/var/lib/mysql"
ENV     MYSQL_DATABASE="mysql-db"
ENV     MYSQL_CHARSET="utf8"
ENV     MYSQL_COLLATION="utf8_general_ci"

# secrets
ENV     MYSQL_USER="mysql"
ENV     MYSQL_PASSWORD="420lemon"
ENV     MYSQL_ROOT_PASSWORD="toor"

ENV     PMA_USER="pma-user"
ENV     PMA_PASS="x?JD?SqmdD"

ENV     WP_DB="wordpressdb"
ENV     WP_USER="wp-user"
ENV     WP_PASS="CKsKsqslMF"

# dependencies
RUN     apk --update --no-cache add bash wget util-linux openrc \
        && mkdir /run/openrc \
        && touch /run/openrc/softlevel

# add mysql user
RUN     adduser -D -g "${MYSQL_USER}" ${MYSQL_USER} && \
        mkdir -p ${MYSQL_DATADIR} && \
        mkdir -p /run/mysqld && \
        chmod -R 775 ${MYSQL_DATADIR} && \
        chmod -R 775 /run/mysqld && \
        chown -R ${MYSQL_USER}:${MYSQL_USER} ${MYSQL_DATADIR} && \
        chown -R ${MYSQL_USER}:${MYSQL_USER} /run/mysqld


# install mariadb
RUN     apk --update --no-cache add \
        mariadb \
        mariadb-common \
        mariadb-client


# install mysql
RUN	mysql_install_db --user=${MYSQL_USER} --ldata=${MYSQL_DATADIR} > /dev/null 
        # echo\
        # "\
        # USE mysql; \
        # FLUSH PRIVILEGES ; \
        # GRANT ALL ON *.* TO 'root'@'%' identified by '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION ; \
        # GRANT ALL ON *.* TO 'root'@'localhost' identified by '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION ; \
        # SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ; \
        # DROP DATABASE IF EXISTS test ; \
        # FLUSH PRIVILEGES ; \
        # " > $( mktemp )

# RUN     rc-service mariadb start
# Configure mysql
COPY    config/setupdb.sh /
RUN     chmod +x /setupdb.sh
COPY    ./config/mariadb-server.cnf ./etc/my.cnf.d/

COPY    config/mysql /sql
# COPY    config/mysql/config.sql /tmp/config.sql

# RUN     mysql -u root < /tmp/preconfig.sql

EXPOSE  3306

# RUN     /usr/bin/mysqld --datadir=${MYSQL_DATADIR} --user=${MYSQL_USER} --skip-networking=0
RUN chmod 0444 /etc/my.cnf.d/mariadb-server.cnf

# CMD     mysql -u root < /tmp/preconfig.sql
ENTRYPOINT ["/bin/bash", "/setupdb.sh"]
