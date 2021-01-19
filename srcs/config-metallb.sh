#!/bin/sh

# define start and end for the ip plage
start="240"
end="250"

#config file to write to
config_file="srcs/metallb/configmap.yaml"

ipbase=$( minikube ip | cut -d. -f-3 )
range="$ipbase.$start-$ipbase.$end"

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

if [[ "$(minikube addons list | grep metallb)" == "" ]]
then
   kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
   kubectl create -f $config_file
check if metalLB is enabled
elif [[ "$(minikube addons list | grep metallb | grep disable)" != "" ]]
then
   minikube addons enable metallb
   kubectl create -f $config_file
fi
echo "$config" > $config_file
kubectl apply -f $config_file || echo $prefix "Cannot apply config" && exit 1

echo $prefix "metallb -> Applied config"