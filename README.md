# FT_SERVICES

42school 2019 curriculum project consisting in automating the deployment and configuration of 5 servers with 2 databases and 1 loadbalancer.
by Nlecaill, Lrobino, Abourbou and Musoufi

# Build && run project

You can launch everything by running: `bash setup.sh`.    
You can choose your driver with: `bash setup.sh --driver="docker|virtualbox"`

Once project is build, you can find log in `setup.log` and connect to dashboard with: `minikube dashboard`.

# servers
Each server is deployed on a different pod.

## Grafana
Grafana is an ...

## Nginx

An Nginx server that can make a redirection 403 on wordpress and a reverse proxy redirection on phpmyadmins.

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

## Scripts

- secret_encrypt.sh: Script thats contain all passwords and print their Base64-encrypt version.
- container-build: Script thats create images from a path to dockerfile.     
- setupdebug: recreate and deploy a service pass in param. (wp, maria, php, nginx).
- configMetalLB: Extention of setup.sh, allow to safely apply a new metallb configmap.

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
DONE Ensure thats metallb use only one IP by adding a spec.loadbalancerIP on services    
TODO Add a kubectl wait to each pods deletion/creation    
DONE Put configs folder in srcs
TODO add a kustomize.yaml
TODO add docker images creation log     
TODO change pma inside position      

-- nginx   
MAYBE change nginx location in container filesystem     
TODO https: ssl error when reach wordpress on port 443     
TODO Faire page d'acceuil pour le server nginx     

-- phpmyadmin    
BUG Connect to phpmyadmin without tables creation's right.    

-- wordpress    
TODO add wp pluggin 
BUG Error SSL protocol:    
when:     
- open wordpress.    
- open pma.  
- modif wp table in pma and save.   
- can't go on wp (redirect to nginx).   

supposition:     
Some ssl key are not valid (maybe browser don't support two identical key).    
