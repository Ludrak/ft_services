#!/bin/sh

# check if minikube is installed
if [[ "$(minikube version | grep "minikube version:")" == "" ]]
then
    echo "Minikube is not installed."
    exit 1
fi

driver=virtualbox
for arg in "$@"
do
    if [[ "$arg" = --driver=* ]]
    then
        driver=$( echo "$arg" | sed "s/--driver=//g")
        if [[ "$driver" != "docker" ]] && [[ "$driver" != "virtualbox" ]]
        then
            driver=virtualbox
        fi 
    fi
done

minikube start --vm-driver=$driver || `echo "No such driver: $driver\ntry running with --driver= option\n" && exit $?`

# check if metallb addon exists
sh ./srcs/config-metallb.sh --file=./srcs/metallb/configmap.yaml

# delete prev nginx
kubectl delete deploy $( kubectl get deploy | grep nginx | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep nginx-loadbalancer | cut -d ' ' -f 1 )
# delete prev wordpress
kubectl delete deploy $( kubectl get deploy | grep wordpress | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep wordpress-loadbalancer | cut -d ' ' -f 1 )
# delete prev phpmyadmin
kubectl delete deploy $( kubectl get deploy | grep phpmyadmin | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep phpmyadmin-loadbalancer | cut -d ' ' -f 1 )
# delete prev mariadb
kubectl delete deploy $( kubectl get deploy | grep mariadb | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep mariadb-loadbalancer | cut -d ' ' -f 1 )

# switch docker to minikube docker
eval $(minikube docker-env)

# build docker image
sh ./srcs/container-build.sh --image=nginx-base-image --path=./srcs/nginx-base

sh ./srcs/container-build.sh --image=nginx-image --path=./srcs/nginx/
sh ./srcs/container-build.sh --image=wordpress-image --path=./srcs/wordpress/
sh ./srcs/container-build.sh --image=phpmyadmin-image --path=./srcs/phpmyadmin/
sh ./srcs/container-build.sh --image=mariadb-image --path=./srcs/mariadb/

# deploy service
kubectl create -f srcs/nginx/deployment.yaml
kubectl create -f srcs/wordpress/deployment.yaml
kubectl create -f srcs/phpmyadmin/deployment.yaml
kubectl create -f srcs/mariadb/deployment.yaml