#! /bin/bash

# start telegraf
cd /telegraf-1.15.2/usr/bin/ && ./telegraf &

# start nginx and php server
php-fpm7

nginx -t 2>&1 >> wp.log

nginx &

wp plugin install theme-my-login --activate --path=${WWW_ROOT}
while [ "$?" != "0" ]
do 
wp plugin install theme-my-login --activate --path=${WWW_ROOT}
done

wp plugin uninstall akismet --deactivate --path=${WWW_ROOT}
wp plugin uninstall hello --deactivate --path=${WWW_ROOT}

while [ 1 ]
do 
    sleep 1
done
