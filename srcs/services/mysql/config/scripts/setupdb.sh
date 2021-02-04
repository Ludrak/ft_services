#! /bin/bash

set -e

# start telegraf
cd /telegraf-1.15.2/usr/bin/ && ./telegraf &
cd /

chown -R ${MYSQL_USER}:${MYSQL_USER} ${MYSQL_DATADIR}
mysql_install_db --user=${MYSQL_USER} --ldata=${MYSQL_DATADIR} > /dev/null 

# Start mysqld
/usr/bin/mysqld --datadir=/var/lib/mysql --user=mysql & 

# Wait until mysqld is ready
/scripts/wait_mysqld_starting.sh

# Once mysqld is started, configure all sql files with good identifiants
sed -i "s~XrootX~$(cat /etc/kub/secret-volume/rootuser)~g" /sql/preconfig.sql
sed -i "s~XrootpassX~$(cat /etc/kub/secret-volume/rootpass)~g" /sql/preconfig.sql
sed -i "s~XadminX~$(cat /etc/kub/secret-volume/adminuser)~g" /sql/preconfig.sql
sed -i "s~XadminpassX~$(cat /etc/kub/secret-volume/adminpass)~g" /sql/preconfig.sql
sed -i "s~XadminX~$(cat /etc/kub/secret-volume/adminuser)~g" /sql/config.sql

# Then create all databases 
mysql -u root < /sql/preconfig.sql
mysql -u root -ptoor < /sql/create_tables.sql
mysql -u root -ptoor < /sql/config.sql
mysql -u root -ptoor < /sql/wordpress.sql

# REVIEW uncomment this for production
# rm -rf /sql 
# rm -rf /setupdb.sh
# chmod 000 /etc/kub

#Restart mysqld to apply changes
pkill mysqld
/usr/bin/mysqld --datadir=/var/lib/mysql --user=mysql