FROM	alpine:3.12
LABEL	maintainer Luca Robino <lrobino@student.42lyon.fr>

# mysql db info
ENV     MYSQL_DATADIR="/var/lib/mysql"
ENV     MYSQL_DATABASE="mysql-db"
ENV     MYSQL_CHARSET="utf8"
ENV     MYSQL_COLLATION="utf8_general_ci"
ENV     MYSQL_USER="mysql"

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

# Configure mysql
COPY    config/scripts /scripts
RUN     chmod -R +x /scripts
COPY    config/mysql /sql
COPY    ./config/mariadb-server.cnf ./etc/my.cnf.d/
RUN     chmod 0444 /etc/my.cnf.d/mariadb-server.cnf

# install telegraf
RUN apk add libc6-compat gcompat \ 
        && wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz

RUN     tar xf telegraf-1.15.2_linux_amd64.tar.gz -C / \
        && rm telegraf-1.15.2_linux_amd64.tar.gz

COPY    config/telegraf/telegraf.conf /etc/telegraf/

EXPOSE  3306

ENTRYPOINT ["/bin/bash", "/scripts/setupdb.sh"]
