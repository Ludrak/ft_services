# FT_SERVICES

Projet du cursus 2019 de l'école 42 consistant à automatiser le déploiement et la configuration de 5 serveurs avec 2 bases de données et 1 loadbalancer.   
by Nlecaill, Lrobino, Abourbou et Musoufi

# serveurs
## Grafana
## Nginx
## Wordpress
Wordpress ID:       admin    
Wordpress password: admin

## Phpmyadmin
Phpmyadmin ID:          admin     
Phpmyadmin password:    adminpass   

Une interface phpmyadmin pour gérer les bases de données de MariaDB.
## FTP

# BDD
## MariaDB
Mariadb ID:         root    
Mariadb password:   toor

## InfluxDB

# Metallb
Metallb est un loadbalancer conçu pour kubernetes.

## Commandes utiles:
- get container logs   
    >`kubectl logs  >pod<   > logs`

- get into a container    
    >`kubectl exec -ti >pod< sh`

### TODO List
TODO Crée volume pour mariadb   
TODO Crée volume pour InfluxDB   
TODO Create secrets for all passwords   
