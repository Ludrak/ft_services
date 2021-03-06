# check process
pidof php-fpm7 && pidof telegraf && pidof nginx

if [[ "$?" != "0" ]]
then
    exit 1;
fi
# check http response
wget --tries=2 http://localhost:5050 --no-check-certificate --spider

if [[ "$?" != "0" ]]
then
    exit 1;
fi

exit 0;