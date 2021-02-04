#! /bin/bash

mysqladmin -u root -ptoor status
while [ $? != 0 ]
do
    sleep 2
    mysqladmin -u root -ptoor status
done

exit 0