# Restart a specific deployment
# ex: bash setupdebug.sh php for restarting phpmyadmin deployment

if [ $1 = "php" ]
then
eval $(minikube docker-env)
kubectl delete deploy $( kubectl get deploy | grep phpmyadmin | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep phpmyadmin-loadbalancer | cut -d ' ' -f 1 )

kubectl delete secret phpmyadmin-secret
kubectl apply -f configs/phpmyadmin-secret.yaml 

sh ./srcs/container-build.sh --image=phpmyadmin-image --path=./srcs/phpmyadmin/
kubectl create -f srcs/phpmyadmin/deployment.yaml
minikube dashboard
fi

if [ $1 = "maria" ]
then
eval $(minikube docker-env)
kubectl delete deploy $( kubectl get deploy | grep mariadb | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep mariadb-service | cut -d ' ' -f 1 )

kubectl delete secret mariadb-secret
kubectl apply -f configs/mariadb-secret.yaml 

sh ./srcs/container-build.sh --image=mariadb-image --path=./srcs/mariadb/
kubectl create -f srcs/mariadb/deployment.yaml
minikube dashboard
fi

if [ $1 = "wp" ]
then
eval $(minikube docker-env)
kubectl delete deploy $( kubectl get deploy | grep wordpress | cut -d ' ' -f 1 )
kubectl delete svc $( kubectl get svc | grep wordpress-loadbalancer | cut -d ' ' -f 1 )
sh ./srcs/container-build.sh --image=wordpress-image --path=./srcs/wordpress/
kubectl create -f srcs/wordpress/deployment.yaml
minikube dashboard
fi