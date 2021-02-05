#!bin/bash

# start telegraf
cd /telegraf-1.15.2/usr/bin/ && ./telegraf &
cd /

#starting influxDB
influxd -config /etc/influxdb.conf
influxd &

while 1
do
	sleep1
done