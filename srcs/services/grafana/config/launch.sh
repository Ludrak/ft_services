#!/bin/sh

# start telegraf
cd /telegraf-1.15.2/usr/bin/ && ./telegraf &
cd /

#launch grafana
#cd /etc/grafana
grafana-server web &


# grafana-cli
#while true
#do
# sleep 1
#done


#	CMD BUILD IMAGE ALPINE AND EXEC IT
#
#	if docker of minikube => eval $(minikube docker-env)
#	docker build -t alpine_grafana .
#
#	docker run -it alpine_grafana sh