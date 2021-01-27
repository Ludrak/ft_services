#! /bin/bash

# colors
GREEN='\033[92m'
YELLOW='\033[93m'
CYAN='\033[96m'
RED='\033[91m'
RESET='\033[0m'
# Logfile
LOG="./srcs/logs/setup.log"

minikube stop && minikube start --vm-driver=virtualbox
eval $(minikube docker-env)

echo -e "$GREEN Create$CYAN metallb$GREEN configmap. $RESET"
sh ./srcs/metallb/create_configmap.sh

echo -e "$GREEN Configure$CYAN metallb$GREEN.$RESET"
kubectl delete configmap -n metallb-system config   2>&1 >> $LOG
kubectl create -f srcs/metallb/configmap.yaml       2>&1 >> $LOG
minikube dashboard