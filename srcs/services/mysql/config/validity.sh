# check process
pidof mysqld && pidof telegraf

if [[ "$?" != "0" ]]
then
    exit 1;
fi
# check http response
mysqladmin -u root -ptoor status

if [[ "$?" != "0" ]]
then
    exit 1;
fi

exit 0;