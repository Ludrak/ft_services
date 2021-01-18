ipbase=$(minikube ip | cut -d. -f-3 )
range="- $ipbase.240-$ipbase.250"
echo "Metallb config range: $range"
sed "s|- - -|${range}|g" "srcs/metallb/configmap-sample.yaml" > "srcs/metallb/configmap.yaml"