#!/bin/sh

# simple build and run script for docker
# use --rm option to delete previously built container

# define a name for tagging container
container_name="nginx"

# define ports to run with
open_ports="-p 80:80"

# log prefix
nginx_prefix="\033[1;37m> [\033[1;36m$container_name\033[0m\033[1;37m]"
reset_c="\033[0m"

if [ "$#" -eq "1" ] && [ "$1" = "--rm" ]
then
    echo $nginx_prefix "Destroying previous container" $reset_c
    docker container rm -f "$container_name"_service
fi

echo $nginx_prefix "Building new container" $reset_c
docker build --rm -t "$container_name"_image ./
err=$?

if [ "$err" -eq "0" ]
then
	echo $nginx_prefix "Running container..." $reset_c
	docker run -d -it --name "$container_name"_service $open_ports "$container_name"_image 
	exit 0
fi

echo $nginx_prefix "Build failed with error code :" $err $reset_c
exit $err
