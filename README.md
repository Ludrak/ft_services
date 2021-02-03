# FT_SERVICES

42school 2019 curriculum project consisting in automating the deployment and configuration of 5 servers with 2 databases and 1 loadbalancer.
by Nlecaill, Lrobino, Abourbou and Musoufi.

# Build && run project

You can launch everything by running: `bash setup.sh`.    
You can choose your driver with: `bash setup.sh --driver="docker|virtualbox"`

Once project is build, you can find log in `srcs/logs/setup.log` and connect to dashboard with: `minikube dashboard`.

# servers
Each server is deployed on a different pod, one container by pod.

## Grafana
Grafana is a monitoring solution that display a real-time servers status.

## Nginx

An Nginx server that can make some redirections:
- /wordpress : 307 redirection on wordpress
- /grafana   : 307 redirection on grafana 
- /phpmyadmin: reverse proxy redirection on phpmyadmin.

## Wordpress
Wordpress ID:       admin    
Wordpress password: admin

A simple pre-configured WordPress website with 1 administrator and 4 subscribers. Defaults plugins are deleted and replaced by "theme-my-login" plugin that allow user to connect from top corner login button.

## Phpmyadmin
Phpmyadmin ID:          admin     
Phpmyadmin password:    adminpass

A web admin pannel for managing databases stored on mariaDB.

## FTPs
ftps ID:          admin     
ftps password:    admin
ftps rootpass:    toor

A ftps server listening on port 21.

# BDD
## MariaDB
Mariadb ID:         root    
Mariadb password:   toor

MariaDB store data of phpmyadmin and wordpress services.

## InfluxDB

An Influxdb database for storing data from telegraf and serve grafana.

# Metallb
Metallb is a loadbalancer designed for kubernetes.     
Metallb allow to have all deployments under only on IP address.    

# Secrets
Secrets are a good way to safely store passwords and other sensible data with kubernetes.    
They are accessible in container by a volume.    
Our secrets are stored in ./srcs/secrets/    
- mariadb-secret
- phpmyadmin-secret

## Scripts

- secret_encrypt.sh: Script thats contain all passwords and print their Base64-encrypt version.
- container-build: Script thats create images from a path to dockerfile.     
- setupdebug: recreate and deploy a service pass in param. (wp, maria, php, nginx).

## Usefull commands:
- get container logs   
    `kubectl logs  >pod<   > logs`

- get into a container    
    `kubectl exec -ti >pod< -- sh`

- delete/create metallb config
    `kubectl delete configmap -n metallb-system config`
    `kubectl create -f srcs/metallb/configmap.yaml`

### TODO List
TODO Create volume for mariadb    
TODO Delete volumes when setup.sh with specific option  
TODO add a kustomize.yaml

-- nginx   
MAYBE Faire page d'acceuil pour le server nginx     

