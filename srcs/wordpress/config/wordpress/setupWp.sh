#! /bin/bash

# start nginx and php server
php-fpm7

#install wordpress plug-in
wp plugin install theme-my-login --activate --path=${WWW_ROOT} 2>&1 >> wp.log

nginx -t 2>&1 >> wp.log
nginx