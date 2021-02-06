#! /bin/bash

# check process
pidof grafana-server && pidof telegraf

if [[ "$?" != "0" ]]
then
    exit 1;
fi
# check http response
wget --tries=2 https://localhost:3000/ --no-check-certificate --spider

if [[ "$?" != "0" ]]
then
    exit 1;
fi

exit 0;