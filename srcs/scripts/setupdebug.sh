#! /bin/bash 

# Restart a specific deployment
# ex: bash setupdebug.sh php for restarting phpmyadmin deployment
if [[ $1 == "php" ]]
then
eval $(minikube docker-env)
kubectl delete deploy $( kubectl get deploy | grep phpmyadmin | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep phpmyadmin-loadbalancer | cut -d ' ' -f 1 )

kubectl delete secret phpmyadmin-secret
kubectl apply -f srcs/secrets/phpmyadmin-secret.yaml 

sh ./srcs/scripts/container-build.sh --image=phpmyadmin-image --path=./srcs/services/phpmyadmin/
kubectl create -f srcs/services/phpmyadmin/deployment.yaml
minikube dashboard
fi

if [[ $1 == "wp" ]]
then
eval $(minikube docker-env)
kubectl delete deploy $( kubectl get deploy | grep wordpress | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep wordpress-loadbalancer | cut -d ' ' -f 1 )
sh ./srcs/scripts/container-build.sh --image=wordpress-image --path=./srcs/services/wordpress/
kubectl create -f srcs/services/wordpress/deployment.yaml
minikube dashboard
fi

if [[ $1 == "nginx" ]]
then
eval $(minikube docker-env)
kubectl delete deploy $( kubectl get deploy | grep nginx | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep nginx-loadbalancer | cut -d ' ' -f 1 )
sh ./srcs/scripts/container-build.sh --image=nginx-image --path=./srcs/services/nginx/
kubectl create -f srcs/services/nginx/deployment.yaml
minikube dashboard
fi

if [[ $1 == "grafana" ]]
then
eval $(minikube docker-env)
kubectl delete deploy $( kubectl get deploy | grep grafana | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep grafana-loadbalancer | cut -d ' ' -f 1 )
sh ./srcs/scripts/container-build.sh --image=grafana-image --path=./srcs/services/grafana/ 
kubectl create -f srcs/services/grafana/deployment.yaml
minikube dashboard
fi

if [[ $1 == "ftps" ]]
then
eval $(minikube docker-env)
kubectl delete deploy $( kubectl get deploy | grep ftps | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep ftps-loadbalancer | cut -d ' ' -f 1 )
sh ./srcs/scripts/container-build.sh --image=ftps-image --path=./srcs/services/ftps/ 
kubectl create -f srcs/services/ftps/deployment.yaml
minikube dashboard
fi

if [[ $1 == "maria" ]]
then
eval $(minikube docker-env)
kubectl delete deploy $( kubectl get deploy | grep mysql | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep mysql-service | cut -d ' ' -f 1 )

kubectl delete secret mysql-secret
kubectl delete pvc/mysql-volume
kubectl apply -f srcs/secrets/mysql-secret.yaml 

sh ./srcs/scripts/container-build.sh --image=mysql-image --path=./srcs/services/mysql/
kubectl create -f srcs/services/mysql/deployment.yaml
minikube dashboard
fi

if [[ $1 == "influx" ]]
then
eval $(minikube docker-env)
kubectl delete deploy $( kubectl get deploy | grep influxdb | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep influxdb-service | cut -d ' ' -f 1 )

kubectl delete secret influxdb-secret
kubectl delete pvc/influxdb-volume
kubectl apply -f configs/influxdb-secret.yaml 

sh ./srcs/scripts/container-build.sh --image=influxdb-image --path=./srcs/services/influxdb/
kubectl create -f srcs/services/influxdb/deployment.yaml
minikube dashboard
fi
