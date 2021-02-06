# check process
pidof sshd && pidof telegraf && pidof nginx

if [[ "$?" != "0" ]]
then
    exit 1;
fi
# check http response
wget --tries=2 http://localhost:80 --spider --no-check-certificate

if [[ "$?" != "0" ]]
then
    exit 1;
fi

exit 0;