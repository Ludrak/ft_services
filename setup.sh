#!/bin/sh

# check if minikube is installed
if [[ "$(minikube version | grep "minikube version:")" == "" ]]
then
    echo "Minikube is not installed."
    exit 1
fi
minikube start --vm-driver=virtualbox

# check if metallb addon exists
if [[ "$(minikube addons list | grep metallb)" == "" ]]
then
    kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
# check if metalLB is enabled
elif [[ "$(minikube addons list | grep metallb | grep disable)" != "" ]]
then
    minikube addons enable metallb
fi
kubectl delete configmap -n metallb-system config
kubectl create -f srcs/metallb/configmap.yaml


# delete prev nginx
kubectl delete deploy $( kubectl get deploy | grep nginx | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep nginx-loadbalancer | cut -d ' ' -f 1 )

kubectl delete deploy $( kubectl get deploy | grep phpmyadmin | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep phpmyadmin-loadbalancer | cut -d ' ' -f 1 )


kubectl delete deploy $( kubectl get deploy | grep wordpress | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep wordpress-loadbalancer | cut -d ' ' -f 1 )

# switch docker to minikube docker
eval $(minikube docker-env)

# build docker image
sh ./srcs/container-build.sh --image=nginx-image --path=./srcs/nginx/
sh ./srcs/container-build.sh --image=wordpress-image --path=./srcs/wordpress/
sh ./srcs/container-build.sh --image=phpmyadmin-image --path=./srcs/phpmyadmin/
sh ./srcs/container-build.sh --image=mysql-image --path=./srcs/mariadb/

# deploy service
kubectl create -f srcs/nginx/deployment.yaml
kubectl create -f srcs/wordpress/deployment.yaml
kubectl create -f srcs/phpmyadmin/deployment.yaml