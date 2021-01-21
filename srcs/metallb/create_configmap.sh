ipbase=$(minikube ip | cut -d. -f-3 )
range="- $ipbase.230-$ipbase.240"
echo "Metallb config range: $range"
sed "s|- - -|${range}|g" "srcs/metallb/configmap-sample.yaml" > "srcs/metallb/configmap.yaml"
chmod 777 srcs/metallb/configmap.yaml