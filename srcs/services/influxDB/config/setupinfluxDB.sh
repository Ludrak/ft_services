#!bin/bash


# start telegraf
cd /telegraf-1.15.2/usr/bin/ && ./telegraf &
cd /

#starting influxDB
influxd