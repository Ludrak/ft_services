#! /bin/bash

# start telegraf
cd /telegraf-1.15.2/usr/bin/ && ./telegraf &
cd /
# start ssh daemon 
/usr/sbin/sshd

# start nginx daemon
nginx
