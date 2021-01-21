set -e

/usr/bin/mysqld --datadir=/var/lib/mysql --user=mysql & 
sleep 4

mysql -u root < /sql/preconfig.sql
mysql -u root -ptoor < /sql/phpmyadmin.sql
/usr/bin/mysqld --datadir=/var/lib/mysql --user=mysql