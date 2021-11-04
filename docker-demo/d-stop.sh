#!/bin/bash

if [ "z$1" == "z" ]; then echo "param!"; exit 1; fi

ID=$(docker ps | grep $1 | awk '{print $1}')
docker stop $ID
docker rm $ID
docker rmi $(docker image ls | grep 'docker-demo' | grep $1 | awk '{print $3}')

echo
echo "====== docker image ls ======"
docker image ls
