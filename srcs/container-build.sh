#!/bin/sh

#
##  container-build.sh - lrobino
##  Basic build script for docker
##  
##  PARAMS:
##
##  --image=<image name>
##  specify a name for the image
##
##  --path=<path>
##  specify a path to Dockerfile
##
##  --container=<container_name>
##  specify a name for running container (only available with --run option)
##
##  --port=<port>
##  specify a port for running container (only available with --run option)
##
##  --run
##  run the image after building it
##
##  --rm
##  remove previously built container
##
##
##  REMOVE OPTIONS:
##
##  --rm-image (or --rmi)
##  cleans all generated docker images which are not associated with an active container
##
##  --rm-containers (or --rmc)
##  shuts down all generated docker containers
##
##  --rm-all (or --rma)
##  cleans all generated docker images and shuts down any active container.
##
##  These variables can also be edited below.
#

## BUILDING
# set the name of the image you want to build (also works with --image=<image name>)
image_name=
#set the path for the Dockerfile to run with (also works with --path=<path>)
image_path=
# remove the previously built container or if set to 1
remove_previous_container=

## RUNNING
# choose which ports you want to open (use docker syntax : "-p 80:80")
open_ports=
# choose a container name for running (also works with --container=<path>)
container_name=
# runs container after built if set to 1
run_after_built=

## REMOVE OPTIONS (You usualy want to run this options by command, see `sh container-build.sh --help`)
# remove all images which are not actually used by a running container
remove_images=
# stops every running containers
stop_containers=
# stops and delete every active container and remove all previously built images
remove_all=

## COLORS
# choose which fancy prefix you want to add
# IMAGE and PATH can be used as keywords to represent image name and path
prefix="\033[1;34mPATH\033[1;37m > [\033[1;32mIMAGE\033[1;37m] :"
# reset suffix
reset="\033[0m"

remove ()
{
    echo $prefix "Removing previously built image" $reset
    docker container rm -f $container_name
}

remove_images()
{
    if [[ "$( docker images --format "{{.ID}}" | sed "s|\n| |g" )" = "" ]]
    then
        echo $prefix "No image to delete" $reset
        exit 1
    fi
    echo $prefix "Removing unactive docker images" $reset
    docker image rm $( docker images --format "{{.ID}}" | sed "s|\n| |g" )
    exit 0
}

stop_containers()
{
    if [[ "$( docker ps --format "{{.ID}}" | sed "s|\n| |g" )" = "" ]]
    then
        echo $prefix "No active container" $reset
        exit 1
    fi
    echo $prefix "Removing containers" $reset
    docker container rm -f $( docker ps --format "{{.ID}}" | sed "s|\n| |g" )
    exit 0
}

remove_all()
{
    if [[ "$( echo $( docker images --format "{{.ID}}" ) $( docker images --format "{{.ID}}" ) )" = "" ]]
    then
        echo $prefix "No image or container to delete" $reset
        exit 1
    fi
    if [[ "$( docker ps --format "{{.ID}}" | sed "s|\n| |g" )" != "" ]]
    then
        echo $prefix "Stopping containers" $reset
        docker container rm -f $( docker ps --format "{{.ID}}" | sed "s|\n| |g" )
    fi
    if [[ "$( docker images --format "{{.ID}}" | sed "s|\n| |g" )" != "" ]]
    then
        echo $prefix "Removing images" $reset
        docker image rm -f $( docker images --format "{{.ID}}" | sed "s|\n| |g" )
    fi
}

build_error=0
build ()
{
    echo $prefix "Building image :" $image_name $reset
    docker build -t $image_name $image_path
    build_error=$?
    if [[ "$build_error" != "0" ]]
    then
        echo $prefix "Building of" $image_name "exited with a status of" $build_error $reset
        exit $build_error
    fi
}

run_error=0
run ()
{
    echo $prefix "Running container" $container_name "on ports" $( echo $open_ports | sed "s/-p //g" ) $reset
    docker run -d -it --name $container_name $open_ports $image_name
    run_error=$?
    if [[ "$run_error" != "0" ]]
    then
        echo $prefix "Running of" $image_name "exited with a status of" $run_error $reset
        exit $run_error
    fi
}

# help menu
if [[ "$#" == "0" ]] || [[ "$1" == "--help" ]]
then
    echo "\033[1;35m> $0 help\033[0m\n
\033[1;37m--help\033[0m
displays this page

\033[1;37m--image=\033[0m<image name>
specify a name for the image

\033[1;37m--path=\033[0m<path>
specify a path to Dockerfile

\033[1;37m--container=\033[0m<container name>
specify a name for running container (only available with --run option)

\033[1;37m--port=\033[0m<port>
specify a port for running container (only available with --run option)
you can specify multiple ports by using --port multiple times

\033[1;37m--run\033[0m
run the image after building it

\033[1;37m--rm\033[0m
remove previously built container


\033[1;31m--rm-images\033[1;37m (or --rmi)\033[0m
remove all previously built images which are not actually used by a container

\033[1;31m--rm-containers\033[1;37m (or --rmc)\033[0m
stop and deletes all containers

\033[1;31m--rm-all\033[1;37m (or --rma)\033[0m
cleans all generated docker images and shuts down any active container.

These options can also be edited as variables in build.sh script."
exit 0
fi

# parse args
for arg in "$@"
do
    if [[ "$arg" = --rma ]] || [[ "$arg" = --rm-all ]]
    then
        remove_all=1
        continue
    elif [[ "$arg" = --rmi ]] || [[ "$arg" = --rm-images ]]
    then
        remove_images=1
        continue
    elif [[ "$arg" = --rmc ]] || [[ "$arg" = --rm-containers ]]
    then
        stop_containers=1
        continue
    elif [[ "$arg" = --rm ]]
    then
        remove_previous_container=1
        continue
    elif [[ "$arg" = --run ]]
    then
        run_after_built=1
        continue
    elif [[ "$arg" = --image=* ]]
    then
        image_name=$( echo $arg | sed "s|--image=||g" )
        continue
    elif [[ "$arg" = --container=* ]]
    then
        container_name=$( echo $arg | sed "s|--container=||g" )
        continue
    elif [[ "$arg" = --path=* ]]
    then
        image_path=$( echo $arg | sed "s|--path=||g" )
        continue
    elif [[ "$arg" = --port=* ]]
    then
        open_ports="$open_ports "$( echo $arg | sed "s|--port=||g" | sed "s/.*/-p &:&/g" )
        continue
    fi
    echo "Unknown argument : \"$arg\"" ;
    exit 1
done

# applying prefix infos
prefix=$( echo $prefix | sed -e "s|IMAGE|$image_name|g" -e "s|PATH|$image_path|g" )

# checks if remove options have been set
if [[ "$remove_all" = "1" ]]
then
    remove_all
fi
if [[ "$remove_images" = "1" ]]
then
    remove_images
fi
if [[ "$stop_containers" = "1" ]]
then
    stop_containers
fi

# check if no image specified
if [[ "$image_name" = "" ]]
then
    echo "No image specified: run with --image= or set \$image_name in bash script." ;
    echo "Aborting" ;
    exit 1 ;
fi

# check if no path specified
if [[ "$image_path" = "" ]]
then
    echo "No image path specified: run with --path= or set \$image_path in bash script." ;
    echo "Aborting" ;
    exit 1 ;
fi

# check if no container name specified
if [[ "$container_name" = "" ]] && [[ "$run_after_built" -eq "1" ]]
then
    echo "No container name specified: run with --container= or set \$container_name in bash script." ;
    echo "This option is only availabe when --run option is set"
    echo "Aborting" ;
    exit 1 ;
fi

# check if needed to remove previous container
if [[ "$remove_previous_container" -eq "1" ]]
then
    remove ;
fi

# building image
build

# run if specified with --run
if [[ "$run_after_built" -eq "1" ]]
then
    run
fi

echo "Done !"
exit 0
