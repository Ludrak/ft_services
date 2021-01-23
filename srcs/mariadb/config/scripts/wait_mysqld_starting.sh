mysqladmin -u root -proot status
while [ $? != 0 ]
do
    sleep 2
    mysqladmin -u root -proot status
done

exit 0