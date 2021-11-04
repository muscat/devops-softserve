#!/bin/bash

read -p "press Enter to clear DATA folders!" QWE

sudo rm -rf       /home/user/docker-demo/mysql/mysql-data/*
sudo chown   user /home/user/docker-demo/mysql/mysql-data

sudo rm -rf       /home/user/docker-demo/web/html/wordpress
