#!/bin/bash

if [ "z$1" == "z" ]; then echo "param!"; exit 1; fi
docker exec -t -i $(docker ps | grep $1 | awk '{print $1}') /bin/bash
