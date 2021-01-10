#!/bin/sh

wp_prefix="\033[1;37m> [\033[1;36mWordpress\033[0m\033[1;37m]"
reset_c="\033[0m"

echo $wp_prefix "Destroying previous container" $reset_c
docker container rm -f wordpress_service
echo $wp_prefix "Building new container" $reset_c
docker build --rm -t wordpress_image ./
err=$?

if [ "$err" -eq "0" ]
then
	echo $wp_prefix "Running container..." $reset_c
	docker run -d -it --name wordpress_service -p 5050:5050 wordpress_image 
	exit 0
fi

echo $wp_prefix "Build failed with error code :" $err $reset_c
exit $err
