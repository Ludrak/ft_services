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
    echo -e "deployment $CYAN$1$RESET available."
}

buildImg(){
    sh ./srcs/scripts/container-build.sh --image=$1-image --path=./srcs/$1/     2>&1 >> $LOG
    echo -e "image $CYAN$1$RESET created."
}

echo -e "${GREEN}-- Start ${CYAN}FT_SERVICES${GREEN} installation --${RESET}"
echo "" > $LOG
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
# check if metallb addon exists
if [[ "$(minikube addons list | grep metallb)" == "" ]]
then
    echo -e "${CYAN}METALLB${GREEN} not found as minikube addon.${RESET}"
    echo -e "${GREEN}Installing ${CYAN}metallb${GREEN} from sources.${RESET}"
    kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml 2>&1 >> $LOG
    kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.3/manifests/metallb.yaml 2>&1 >> $LOG
    kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

# check if metalLB is enabled
elif [[ "$(minikube addons list | grep metallb | grep disable)" != "" ]]
then
    echo -e "${GREEN}Activing ${CYAN}metallb${GREEN} addon.${RESET}"
    minikube addons enable metallb
fi


# delete prev nginx
echo -e "${GREEN}Deleting existant deployments and services${RESET}"
echo -e "- Delete ${YELLOW}NGINX${RESET}"
kubectl delete deploy $( kubectl get deploy | grep nginx | cut -d ' ' -f 1 )                    2>&1 >> $LOG
kubectl delete svc $( kubectl get svc | grep nginx-loadbalancer | cut -d ' ' -f 1 )             2>&1 >> $LOG
echo -e "- Delete ${YELLOW}PHPMYADMIN${RESET}"
kubectl delete deploy $( kubectl get deploy | grep phpmyadmin | cut -d ' ' -f 1 )               2>&1 >> $LOG
kubectl delete svc $( kubectl get svc | grep phpmyadmin-loadbalancer | cut -d ' ' -f 1 )        2>&1 >> $LOG
echo -e "- Delete ${YELLOW}MARIADB${RESET}"
kubectl delete deploy $( kubectl get deploy | grep mariadb | cut -d ' ' -f 1 )                  2>&1 >> $LOG
kubectl delete svc $( kubectl get svc | grep mariadb-service | cut -d ' ' -f 1 )                2>&1 >> $LOG
echo -e "- Delete ${YELLOW}WORDPRESS${RESET}"
kubectl delete deploy $( kubectl get deploy | grep wordpress | cut -d ' ' -f 1 )                2>&1 >> $LOG
kubectl delete svc $( kubectl get svc | grep wordpress-loadbalancer | cut -d ' ' -f 1 )         2>&1 >> $LOG

# delete prev secrets
echo -e "${GREEN}Deleting existant secrets.${RESET}"
kubectl delete secret mariadb-secret
kubectl delete secret phpmyadmin-secret

# switch docker to minikube docker
echo -e "${GREEN}Switching ${CYAN}docker${GREEN} environnement${RESET}"
eval $(minikube docker-env)


# Create secrets
echo -e "${GREEN}Creating new secrets${RESET}"
kubectl apply -f srcs/configs/mariadb-secret.yaml
kubectl apply -f srcs/configs/phpmyadmin-secret.yaml

# build docker image
echo -e "${GREEN}Creating docker images.${RESET}"
buildImg nginx-base
buildImg nginx
buildImg mariadb
buildImg wordpress
buildImg phpmyadmin

# deploy service
echo -e "${GREEN}Creating deployments.${RESET}"
deploy nginx
deploy mariadb
deploy wordpress
deploy phpmyadmin

./srcs/scripts/configMetalLB.sh