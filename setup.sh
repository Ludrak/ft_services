#!/bin/bash

GREEN='\033[92m'
YELLOW='\033[93m'
CYAN='\033[96m'
RED='\033[91m'
RESET='\033[0m'

echo -e "${GREEN}-- Start ${CYAN}FT_SERVICES${GREEN} installation --${RESET}"

# check if minikube is installed
if [[ "$(minikube version | grep "minikube version:")" == "" ]]
then
    echo -e "${RED}Minikube is not installed.${RESET}"
    exit 1
fi

echo -e "${GREEN}Starting ${CYAN}MINIKUBE${RESET}"
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
# minikube addons disable metallb
# check if metallb addon exists
if [[ "$(minikube addons list | grep metallb)" == "" ]]
then
    echo -e "${CYAN}METALLB${GREEN} not found as minikube addon.${RESET}"
    echo -e "${GREEN}Installing ${CYAN}metallb${GREEN} from sources.${RESET}"
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml >> setup.log
    kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.3/manifests/metallb.yaml >> setup.log
    $ kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

# check if metalLB is enabled
elif [[ "$(minikube addons list | grep metallb | grep disable)" != "" ]]
then
    echo -e "${GREEN}Activing ${CYAN}metallb${GREEN} addon.${RESET}"
    minikube addons enable metallb
    # kubectl delete configmap -n metallb-system config                                               >> setup.log
    # kubectl create -f srcs/metallb/configmap.yaml                                                   >> setup.log

fi
# kubectl delete configmap -n metallb-system config                                               >> setup.log
# kubectl create configmap config --from-file=srcs/metallb/configmap.yaml -n metallb-system       >> setup.log
echo -e "${GREEN}Create ${CYAN}metallb${GREEN} configmap.${RESET}"
sh ./srcs/metallb/create_configmap.sh

# delete prev nginx
echo -e "${GREEN}Deleting existant deployments and services${RESET}"
echo -e "- Delete ${YELLOW}NGINX${RESET}"
kubectl delete deploy $( kubectl get deploy | grep nginx | cut -d ' ' -f 1 )                    2>&1 >> setup.log
kubectl delete svc $( kubectl get svc | grep nginx-loadbalancer | cut -d ' ' -f 1 )             2>&1 >> setup.log
echo -e "- Delete ${YELLOW}PHPMYADMIN${RESET}"
kubectl delete deploy $( kubectl get deploy | grep phpmyadmin | cut -d ' ' -f 1 )               2>&1 >> setup.log
kubectl delete svc $( kubectl get svc | grep phpmyadmin-loadbalancer | cut -d ' ' -f 1 )        2>&1 >> setup.log
echo -e "- Delete ${YELLOW}MARIADB${RESET}"
kubectl delete deploy $( kubectl get deploy | grep mariadb | cut -d ' ' -f 1 )                  2>&1 >> setup.log
kubectl delete svc $( kubectl get svc | grep mariadb-service | cut -d ' ' -f 1 )                2>&1 >> setup.log
echo -e "- Delete ${YELLOW}WORDPRESS${RESET}"
kubectl delete deploy $( kubectl get deploy | grep wordpress | cut -d ' ' -f 1 )                2>&1 >> setup.log
kubectl delete svc $( kubectl get svc | grep wordpress-loadbalancer | cut -d ' ' -f 1 )         2>&1 >> setup.log

# delete prev secrets
echo -e "${GREEN}Deleting existant secrets${RESET}"
kubectl delete --all secrets -n default
# kubectl delete secret mariadb-secret
# kubectl delete secret phpmyadmin-secret

# switch docker to minikube docker
echo -e "${GREEN}Switching ${CYAN}docker${GREEN} environnement${RESET}"
eval $(minikube docker-env)


# Create secrets
echo -e "${GREEN}Creating new secrets${RESET}"
kubectl apply -f srcs/configs/mariadb-secret.yaml
kubectl apply -f srcs/configs/phpmyadmin-secret.yaml

# build docker image
echo -e "${GREEN}Creating docker images.${RESET}"
sh ./srcs/scripts/container-build.sh --image=nginx-base-image --path=./srcs/nginx-base                  >> setup.log

sh ./srcs/scripts/container-build.sh --image=nginx-image --path=./srcs/nginx/                           >> setup.log
sh ./srcs/scripts/container-build.sh --image=wordpress-image --path=./srcs/wordpress/                   >> setup.log
sh ./srcs/scripts/container-build.sh --image=phpmyadmin-image --path=./srcs/phpmyadmin/                 >> setup.log
sh ./srcs/scripts/container-build.sh --image=mariadb-image --path=./srcs/mariadb/                       >> setup.log

# deploy service
echo -e "${GREEN}Creating deployments${RESET}"

kubectl create -f srcs/mariadb/deployment.yaml
kubectl wait --for=condition=Available deployment/mariadb
kubectl create -f srcs/wordpress/deployment.yaml
kubectl wait --for=condition=Available deployment/wordpress
kubectl create -f srcs/nginx/deployment.yaml
kubectl wait --for=condition=Available deployment/nginx
kubectl create -f srcs/phpmyadmin/deployment.yaml
kubectl wait --for=condition=Available deployment/phpmyadmin


echo -e "${GREEN}Configure metallb configmap${RESET}"
./srcs/scripts/configMetalLB.sh