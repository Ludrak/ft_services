#!/bin/sh

# check if minikube is installed
# if [[ "$(minikube version | grep "minikube version:")" == "" ]]
# then
#     echo "Minikube is not installed."
#     exit 1
# fi

# # check if metalLB is enabled
# if [[ "$(minikube addons list | grep metallb | grep disable)" != "" ]]
# then
#     minikube addons enable metallb
# fi

# minikube addons configure metallb

# minikube start

# exit 0

# building docker containers
sh ./srcs/container-build.sh --rm --image=nginx_image --path=./srcs/nginx/ --run --port=80 --container=nginx_container
sh ./srcs/container-build.sh --rm --image=wordpress_image --path=./srcs/wordpress/ --run --port=5050 --container=wordpress_container
sh ./srcs/container-build.sh --rm --image=mariadb_image --path=./srcs/mariadb/ --run --port=3306 --container=mariadb_container

# kubectl create deployment nginx --image=nginx_image
# kubectl create deployment wordpress --image=wordpress_image
# kubectl create deployment mariadb --image=mariadb_image

# kubectl expose deployment nginx --type=LoadBalancer --port=80 --target-port=80
# kubectl expose deployment wordpress --type=LoadBalancer --port=5050 --target-port=5050
# kubectl expose deployment mariadb --type=LoadBalancer --port=3306 --target-port=3306