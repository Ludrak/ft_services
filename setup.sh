#!/bin/sh

# check if minikube is installed
if [[ "$(minikube version | grep "minikube version:")" == "" ]]
then
    echo "Minikube is not installed."
    exit 1
fi
minikube start --driver=virtualbox

# check if metallb addon exists
if [[ "$(minikube addons list | grep metallb)" == "" ]]
then

    # kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.5/manifests/namespace.yaml
    kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml

# check if metalLB is enabled
elif [[ "$(minikube addons list | grep metallb | grep disable)" != "" ]]
then
    minikube addons enable metallb
fi
sh ./srcs/metallb/create_configmap.sh
kubectl delete configmap -n metallb-system config
kubectl create configmap config --from-file=srcs/metallb/configmap.yaml -n metallb-system

# delete prev nginx
kubectl delete deploy $( kubectl get deploy | grep nginx | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep nginx-loadbalancer | cut -d ' ' -f 1 )

kubectl delete deploy $( kubectl get deploy | grep phpmyadmin | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep phpmyadmin-loadbalancer | cut -d ' ' -f 1 )

kubectl delete deploy $( kubectl get deploy | grep mariadb | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep mariadb-service | cut -d ' ' -f 1 )

kubectl delete deploy $( kubectl get deploy | grep wordpress | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep wordpress-loadbalancer | cut -d ' ' -f 1 )

# delete prev secrets
kubectl delete secret mariadb-secret
kubectl delete secret phpmyadmin-secret

# switch docker to minikube docker
eval $(minikube docker-env)

# Create secrets
kubectl apply -f configs/mariadb-secret.yaml 
kubectl apply -f configs/phpmyadmin-secret.yaml 

# build docker image
sh ./srcs/container-build.sh --image=nginx-image --path=./srcs/nginx/
sh ./srcs/container-build.sh --image=wordpress-image --path=./srcs/wordpress/
sh ./srcs/container-build.sh --image=phpmyadmin-image --path=./srcs/phpmyadmin/
sh ./srcs/container-build.sh --image=mariadb-image --path=./srcs/mariadb/

# deploy service
kubectl create -f srcs/nginx/deployment.yaml
kubectl create -f srcs/wordpress/deployment.yaml
kubectl create -f srcs/phpmyadmin/deployment.yaml
kubectl create -f srcs/mariadb/deployment.yaml

sleep 5
kubectl delete configmap -n metallb-system config
sleep 5
kubectl create -f srcs/metallb/configmap.yaml
