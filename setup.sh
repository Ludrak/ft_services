#!/bin/bash

# colors
GREEN='\033[92m'
YELLOW='\033[93m'
CYAN='\033[96m'
RED='\033[91m'
RESET='\033[0m'

# Logfile
LOG="./srcs/logs/setup.log"

# functions
deploy (){
    kubectl create -f srcs/$1/deployment.yaml               2>&1 >> $LOG
    kubectl wait --for=condition=Available deployment/$1    2>&1 >> $LOG
    printf "deployment $CYAN$1$RESET available.\n"
}

buildImg(){
    sh ./srcs/scripts/container-build.sh --image=$1-image --path=./srcs/$1/     2>&1 >> $LOG
    printf "image $CYAN$1$RESET created.\n"
}

#init log
mkdir ./srcs/logs        >> /dev/null 2>&1
touch $LOG               >> /dev/null 2>&1
printf "" > $LOG        

printf "${GREEN}-- Start ${CYAN}FT_SERVICES${GREEN} installation --${RESET}\n"
# check if minikube is installed
if [[ "$(minikube version | grep "minikube version:")" == "" ]]
then
    printf "${RED}Minikube is not installed.${RESET}\n"
    exit 1
fi

printf "${GREEN}Starting ${CYAN}MINIKUBE${RESET}\n"
driver=virtualbox
for arg in "$@"
do
    if [[ "$arg" = --driver=* ]]
    then
        driver=$( printf "$arg" | sed "s/--driver=//g")
        if [[ "$driver" != "docker" ]] && [[ "$driver" != "virtualbox" ]]
        then
            driver=virtualbox
        fi
    fi
done

minikube start --vm-driver=$driver || `printf "No such driver: $driver\ntry running with --driver= option\n" && exit $?`
# check if metallb addon exists
if [[ "$(minikube addons list | grep metallb)" == "" ]]
then
    printf "${CYAN}METALLB${GREEN} not found as minikube addon.${RESET}\n"
    printf "${GREEN}Installing ${CYAN}metallb${GREEN} from sources.${RESET}\n"
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml 2>&1 >> $LOG
    kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.3/manifests/metallb.yaml 2>&1 >> $LOG
    kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

# check if metalLB is enabled
elif [[ "$(minikube addons list | grep metallb | grep disable)" != "" ]]
then
    printf "${GREEN}Activing ${CYAN}metallb${GREEN} addon.${RESET}\n"
    minikube addons enable metallb
fi


# delete prev nginx
printf "${GREEN}Deleting existant deployments and services${RESET}\n"
printf "- Delete ${YELLOW}NGINX${RESET}\n"
kubectl delete deploy $( kubectl get deploy | grep nginx | cut -d ' ' -f 1 )                    2>&1 >> $LOG
kubectl delete svc $( kubectl get svc | grep nginx-loadbalancer | cut -d ' ' -f 1 )             2>&1 >> $LOG
printf "- Delete ${YELLOW}PHPMYADMIN${RESET}\n"
kubectl delete deploy $( kubectl get deploy | grep phpmyadmin | cut -d ' ' -f 1 )               2>&1 >> $LOG
kubectl delete svc $( kubectl get svc | grep phpmyadmin-loadbalancer | cut -d ' ' -f 1 )        2>&1 >> $LOG
printf "- Delete ${YELLOW}MARIADB${RESET}\n"
kubectl delete deploy $( kubectl get deploy | grep mariadb | cut -d ' ' -f 1 )                  2>&1 >> $LOG
kubectl delete svc $( kubectl get svc | grep mariadb-service | cut -d ' ' -f 1 )                2>&1 >> $LOG
printf "- Delete ${YELLOW}WORDPRESS${RESET}\n"
kubectl delete deploy $( kubectl get deploy | grep wordpress | cut -d ' ' -f 1 )                2>&1 >> $LOG
kubectl delete svc $( kubectl get svc | grep wordpress-loadbalancer | cut -d ' ' -f 1 )         2>&1 >> $LOG

# delete prev secrets
printf "${GREEN}Deleting existant secrets.${RESET}\n"
kubectl delete secret mariadb-secret
kubectl delete secret phpmyadmin-secret

# switch docker to minikube docker
printf "${GREEN}Switching ${CYAN}docker${GREEN} environnement${RESET}\n"
eval $(minikube docker-env)


# Create secrets
printf "${GREEN}Creating new secrets${RESET}\n"
kubectl apply -f srcs/configs/mariadb-secret.yaml
kubectl apply -f srcs/configs/phpmyadmin-secret.yaml

# build docker image
printf "${GREEN}Creating docker images.${RESET}\n"
buildImg nginx-base
buildImg nginx
buildImg mariadb
buildImg wordpress
buildImg phpmyadmin

# deploy service
printf "${GREEN}Creating deployments.${RESET}\n"
deploy nginx
deploy mariadb
deploy wordpress
deploy phpmyadmin

# apply metallb config
minikube stop && minikube start --vm-driver=virtualbox
eval $(minikube docker-env)

printf "$GREEN Create$CYAN metallb$GREEN configmap. $RESET\n"
sh ./srcs/metallb/create_configmap.sh

printf "$GREEN Configure$CYAN metallb$GREEN.$RESET\n"
kubectl delete configmap -n metallb-system config   2>&1 >> $LOG
kubectl create -f srcs/metallb/configmap.yaml       2>&1 >> $LOG
minikube dashboard
# ./srcs/scripts/configMetalLB.sh