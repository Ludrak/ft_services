set -e

#Start mysqld
/usr/bin/mysqld --datadir=/var/lib/mysql --user=mysql & 
sleep 4

#Once mysqld is started, create all databases
mysql -u root < /sql/preconfig.sql
mysql -u root -ptoor < /sql/create_tables.sql
mysql -u root -ptoor < /sql/config.sql
mysql -u root -ptoor < /sql/wordpress.sql

#Restart mysqld
pkill mysqld
/usr/bin/mysqld --datadir=/var/lib/mysql --user=mysql