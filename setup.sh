#!/bin/sh

# check if minikube is installed
if [[ "$(minikube version | grep "minikube version:")" == "" ]]
then
    echo "Minikube is not installed."
    exit 1
fi

# check if metallb addon exists
if [[ "$(minikube addons list | grep metallb)" == "" ]]
then
    kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
    kubectl create -f metallb/configmap.yaml

# check if metalLB is enabled
elif [[ "$(minikube addons list | grep metallb | grep disable)" != "" ]]
then
    minikube addons enable metallb
    kubectl create -f metallb/configmap.yaml
fi

minikube start

# delete prev nginx
kubectl delete deploy $( kubectl get deploy | grep nginx | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep nginx-loadbalancer | cut -d ' ' -f 1 )

# switch docker to minikube docker
eval $(minikube docker-env)

# build docker image
sh ./srcs/container-build.sh --image=nginx-image --path=./srcs/nginx/
sh ./srcs/container-build.sh --image=wordpress-image --path=./srcs/wordpress/

# deploy service
kubectl create -f srcs/nginx/deployment.yaml
kubectl create -f srcs/wordpress/deployment.yaml