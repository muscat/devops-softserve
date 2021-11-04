#!/bin/bash

docker-compose up -d --build

ID=$(docker ps | grep 'docker-demo' | grep web | awk '{print $1}')
IP=$(docker inspect --format '{{ range .NetworkSettings.Networks}}{{.IPAddress }}{{end}}' $ID)
sudo sed -i "s/^.*ssl-demo.muscat.rv.ua$//" /etc/hosts
echo "$IP   ssl-demo.muscat.rv.ua" | sudo tee -a /etc/hosts

clear
echo "after containers deployed (est.1-2 minutes) you may surf to ssl-demo.muscat.rv.ua"
