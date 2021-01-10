#!/bin/sh

#NGINX SETUP
echo "[\033[1;35mft_services\033[0m] Building nginx container..."
sh srcs/nginx/run.sh

#WORDPRESS SETUP
echo "\n[\033[1;35mft_services\033[0m] Building wordpress container..."
sh srcs/wordpress/run.sh