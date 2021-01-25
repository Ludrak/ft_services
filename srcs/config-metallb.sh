#!/bin/sh

# define max number of ip that you need to allow
ip_count="127"

#config file to write to
config_file="srcs/metallb/configmap.yaml"

ip_start=$( echo $(minikube ip | cut -d. -f-3).$(expr $(minikube ip | cut -d. -f4) + 1) )
ip_end=$( echo $(minikube ip | cut -d. -f-3).$(expr $(minikube ip | cut -d. -f4) + 1 + $ip_count) )
range="$ip_start-$ip_end"

#config file
config=$(echo "
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
    - $range
")

prefix="[METALLB] :"

for arg in "$@"
do
    if [[ "$arg" = --file=* ]]
    then
        config_file=$( echo "$arg" | sed "s|--file=||g")
    fi
done

#check if metalLB is enabled
if [[ "$(minikube addons list | grep metallb)" == "" ]]
then
   kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
   echo "$config" > $config_file
   kubectl create configmap config --from-file=$config_file -n metallb-system
   #kubectl create -f $config_file
elif [[ "$(minikube addons list | grep metallb | grep disable)" != "" ]]
then
   minikube addons enable metallb
   echo "$config" > $config_file
   kubectl create configmap config --from-file=$config_file -n metallb-system
fi
echo "$config" > $config_file
kubectl apply -f $config_file || echo $prefix "Cannot apply config" && exit 1
kubectl create -f $config_file

echo $prefix "metallb -> Applied config"