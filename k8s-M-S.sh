#!/bin/bash

# Update package lists
sudo apt-get update

# Install Docker
sudo apt install docker.io -y
sudo chmod 666 /var/run/docker.sock

# Install dependencies for Kubernetes
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

# Add Kubernetes repository
sudo mkdir -p -m 755 /etc/apt/keyrings
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update package lists again
sudo apt update

# Install Kubernetes components
sudo apt install -y kubeadm=1.28.1-1.1 kubelet=1.28.1-1.1 kubectl=1.28.1-1.1
