#!/bin/bash

# exit on error

# colors
GREEN='\033[92m'
YELLOW='\033[93m'
CYAN='\033[96m'
RED='\033[91m'
RESET='\033[0m'

# Logfile
LOG="./srcs/logs/setup.log"

# functions
delete ()
{
	printf "Delete ${YELLOW}$(echo "$1" | tr '[:lower:]' '[:upper:]')${RESET}.\n"
	if [[ $2 == "db" ]]
	then
		kubectl delete svc $( kubectl get svc | grep $1-service | cut -d ' ' -f 1 )            		  >> $LOG 2>&1
	else
		kubectl delete svc $( kubectl get svc | grep $1-loadbalancer | cut -d ' ' -f 1 )         	  >> $LOG 2>&1 
	fi
	kubectl delete deploy $( kubectl get deploy | grep $1 | cut -d ' ' -f 1 )                   	  >> $LOG 2>&1
	kubectl wait --for=delete --timeout=60s deployment/$1

}

deploy ()
{
    kubectl create -f srcs/services/$1/deployment.yaml                  2>&1 >> $LOG
    kubectl wait --for=condition=Available deployment/$1                2>&1 >> $LOG
	if [[ $? == 0 ]]
	then
	    printf "deployment $CYAN$1$RESET available.\n"
	else
	    printf "${RED}deployment $CYAN$1$RED failure.${RESET}\n"
	fi
}

buildImg()
{
    printf "building $CYAN$1$RESET ..."
    sh ./srcs/scripts/container-build.sh --image=$1-image --path=./srcs/services/$1/     2>&1 >> $LOG
    if [[ $? -eq '0' ]] ; then
        printf "\rimage $CYAN$1$RESET created.\n";
    else
        echo "\rimage $CYAN$1$RESET$RED failed$RESET : $?\n"
    fi
}

#init log
mkdir -p $( dirname $LOG )  >> /dev/null 2>&1
touch $LOG                  >> /dev/null 2>&1
printf ""                   > $LOG        

printf "${GREEN}-- Start ${CYAN}FT_SERVICES${GREEN} installation --${RESET}\n"
# check if minikube is installed
if [[ "$(minikube version | grep "minikube version:")" == "" ]]
then
    printf "${RED}Minikube is not installed.${RESET}\n"
    exit 1
fi

printf "${GREEN}Starting ${CYAN}MINIKUBE$GREEN.$RESET\n"
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

minikube start --driver=$driver || `printf "No such driver: $driver\ntry running with --driver= option.\n" && exit $?`
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
delete	nginx
delete	wordpress
delete	phpmyadmin
delete	grafana
delete  ftps
delete	mysql		db
delete	influxdb	db

# delete prev secrets
printf "${GREEN}Deleting existant secrets.${RESET}\n"
kubectl delete secret mysql-secret
kubectl delete secret phpmyadmin-secret

# switch docker to minikube docker
printf "${GREEN}Switching ${CYAN}docker$GREEN environnements${RESET}\n"
eval $(minikube docker-env)

# apply role bindings
# kubectl apply -f srcs/role-binding.yaml

# Create secrets
printf "${GREEN}Creating new secrets${RESET}\n"
# kubectl apply -f srcs/secrets/mysql-secret.yaml
# kubectl apply -f srcs/secrets/phpmyadmin-secret.yaml

# build docker image
printf "${GREEN}Creating docker images.${RESET}\n"
buildImg nginx-base
buildImg nginx
buildImg mysql
buildImg wordpress
buildImg phpmyadmin
buildImg influxdb
buildImg grafana
buildImg ftps
sh ./srcs/metallb/create_configmap.sh

kubectl apply -k ./srcs/

# deploy service
# printf "${GREEN}Creating deployments.${RESET}\n"
# deploy influxdb
# deploy mysql
# deploy nginx
# deploy wordpress
# deploy phpmyadmin
# deploy ftps
# deploy grafana

# apply metallb config
# printf $GREEN "Restarting$CYAN Minikube$GREEN.$RESET\n"
# minikube stop && minikube start --vm-driver=virtualbox
# eval $(minikube docker-env)

# printf $GREEN "Create$CYAN metallb$GREEN configmap. $RESET\n"
sh ./srcs/metallb/create_configmap.sh

# printf $GREEN "Configure$CYAN metallb$GREEN.$RESET\n"
# kubectl delete configmap -n metallb-system config   2>&1 >> $LOG
# kubectl create -f srcs/metallb/configmap.yaml       2>&1 >> $LOG
minikube dashboard
