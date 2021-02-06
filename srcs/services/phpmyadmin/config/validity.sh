# check process
pidof php-fpm7 && pidof telegraf && pidof nginx

if [[ "$?" != "0" ]]
then
    exit 1;
fi

# check http response
wget --spider --tries=2 http://localhost:5000/phpmyadmin  --no-check-certificate
if [[ "$?" != "0" ]]
then
    exit 1;
fi

exit 0;