# FT_SERVICES

42school 2019 curriculum project consisting in automating the deployment and configuration of 5 servers with 2 databases and 1 loadbalancer.

# servers
Each server is deployed on a different pod.

## Grafana
## Nginx

An Nginx server that can make a redirection 403 on wordpress and a ... .

## Wordpress
Wordpress ID:       admin    
Wordpress password: admin

A simple pre-configured WordPress website.

## Phpmyadmin
Phpmyadmin ID:          admin     
Phpmyadmin password:    adminpass

A web admin pannel for managing databases stored on mariaDB.

## FTP

# BDD
## MariaDB
Mariadb ID:         root    
Mariadb password:   toor

MariaDB store data of phpmyadmin and wordpress services.

## InfluxDB

# Metallb
Metallb est un loadbalancer conçu pour kubernetes.

# Secrets
Secrets are a good way to safely store passwords and other sensible data with kubernetes.    
They are accessible in container by a volume.    
Our secrets are stored in ./configs    
- mariadb-secret
- phpmyadmin-secret

## Usefull commands:
- get container logs   
    `kubectl logs  >pod<   > logs`

- get into a container    
    `kubectl exec -ti >pod< sh`

- delete/create metallb config
    `kubectl delete configmap -n metallb-system config`
    `kubectl create -f srcs/metallb/configmap.yaml`

### TODO List
TODO Add a command line for auto install wordpress plugins 
TODO Create volume for mariadb    
TODO Create volume for InfluxDB    
TODO Container-build.sh: add a single output ligne when image finish to create     
TODO Ensure thats metallb use only one IP by adding a spec.loadbalancerIP on services    
TODO Add a kubectl wait to each pods deletion/creation    
TODO Put configs folder in srcs