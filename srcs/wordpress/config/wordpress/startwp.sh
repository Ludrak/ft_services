#! /bin/bash

# start nginx and php server
php-fpm7 && nginx

#install wordpress plug-in
wp plugin install theme-my-login --activate --path=${WWW_ROOT}
