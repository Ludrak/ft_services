# check process
pidof vsftpd && pidof telegraf

if [[ "$?" != "0" ]]
then
    exit 1;
fi
# check http response
wget --tries=2 ftp://localhost:21 --spider --no-check-certificate --user="admin" --password="admin" --no-passive-ftp
if [[ "$?" != "0" ]]
then
    exit 1;
fi

exit 0;