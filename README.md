# FT_SERVICES

42school 2019 curriculum project consisting in automating the deployment and configuration of 5 servers with 2 databases and 1 loadbalancer with kubernetes (minikube).     
by Nlecaill, Lrobino, Abourbou and Musoufi.

# Build && run project

You can launch everything by running: `bash setup.sh`.     
You can choose your driver with: `bash setup.sh --driver="docker|virtualbox"`    
You can add `--delete` flag to delete previous env.    

Once project is build, you can find log in `srcs/logs/setup.log` and connect to dashboard with: `minikube dashboard`.

# servers
Each server is deployed on a different pod, one container by pod.    
Container images are build from Alpine:3.12 distribution.
 
All pods are persitent. They will be automatically recreate if they crash.     
Databases data are persistant too.

## Grafana
grafana ID:       admin    
grafana password: admin

Grafana is a monitoring solution that display a real-time servers status.

## Nginx

An Nginx server that can make some redirections:
- /wordpress : 307 redirection on wordpress
- /grafana   : 307 redirection on grafana 
- /phpmyadmin: reverse proxy redirection on phpmyadmin.

## Wordpress
Wordpress ID:       admin    
Wordpress password: admin

A simple pre-configured WordPress website with 1 administrator and 4 subscribers.       
Defaults plugins are deleted and replaced by "theme-my-login" plugin that allow user to connect from top corner login button.

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
mysql ID:         root    
mysql password:   toor

mysql store data of phpmyadmin and wordpress services.

## InfluxDB
telegraf ID:         telegraf    
telegraf password:   telegraf

An Influxdb database for storing data from telegrafs in every containers.    
Grafana will use those data for displaying dashboards.

# Metallb
Metallb is a loadbalancer designed for kubernetes.     
Metallb allow to have all deployments under only on IP address.    

# Secrets
Secrets are a good way to safely store passwords and other sensible data with kubernetes.    
They are accessible in container by a volume.    
Our secrets are stored in ./srcs/secrets/    
- mysql-secret
- phpmyadmin-secret

## Scripts

- **secret_encrypt.sh**:    Script thats contain all passwords and print their Base64-encrypt version.
- **container-build**:      Script thats create images from a path to dockerfile.     
- **setupdebug**:           recreate and deploy a service pass in param. (wp, maria, php, nginx, grafana).

## Usefull commands:
- get container logs   
    `kubectl logs  >pod<   > logs`

- get into a container    
    `kubectl exec -ti >pod< -- sh`

- delete/create metallb config
    `kubectl delete configmap -n metallb-system config`
    `kubectl create -f srcs/metallb/configmap.yaml`