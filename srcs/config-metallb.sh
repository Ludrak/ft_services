
# define start and end for the ip plage
start="240"
end="250"

config_file="srcs/metallb/configmap.yaml"
for arg in "$@"
do
    if [[ "$arg" = --file=* ]]
    then
        config_file=$( echo "$arg" | sed "s|--file=||g")
    fi
done

ipbase=$( minikube ip | cut -d. -f-3 )
range="$ipbase.$start-$ipbase.$end"

echo "
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
    - $range" > $config_file || `echo "$config_file: No such file, aborting config creation" ; exit 1`

echo "metallb -> Applied config"