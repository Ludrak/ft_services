set -e

/usr/bin/mysqld --datadir=/var/lib/mysql --user=mysql & 
sleep 4
mysql -u root < /sql/preconfig.sql
mysql -u root -ptoor < /sql/create_tables.sql
mysql -u root -ptoor < /sql/config.sql

pkill mysqld
/usr/bin/mysqld --datadir=/var/lib/mysql --user=mysql