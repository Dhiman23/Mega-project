#!/bin/bash

sudo apt-get update

sudo apt install docker.io -y 
sudo chmod 666 /var/run/docker.sock 

sudo docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
