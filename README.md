# FT_SERVICES

Projet du cursus 2019 de l'école 42 consistant à automatiser le déploiement et la configuration de 5 serveurs avec 2 bases de données et 1 loadbalancer.

# serveurs
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

## Commandes utiles:
- get container logs   
    kubectl logs  >pod<   > logs

- get into a container    
    kubectl exec -ti >pod< sh

### TODO List
TODO Crée volume pour mariadb
TODO Crée volume pour InfluxDB
TODO Ensure thats metallb use only one IP by adding a spec.loadbalancerIP on services