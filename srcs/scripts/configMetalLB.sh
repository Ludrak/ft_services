minikube stop && minikube start --vm-driver=virtualbox
eval $(minikube docker-env)
kubectl delete configmap -n metallb-system config                                               >> setup.log
kubectl create -f srcs/metallb/configmap.yaml                                                   >> setup.log
minikube dashboard