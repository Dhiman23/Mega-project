#!/bin/bash

sudo apt-get update

sudo apt install docker.io -y 
sudo chmod 666 /var/run/docker.sock 

sudo docker run -d --name nexsus -p 8081:8081 sonatype/nexus3