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
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update package lists again
sudo apt update

# Install Kubernetes components
sudo apt install -y kubeadm=1.28.1-1.1 kubelet=1.28.1-1.1 kubectl=1.28.1-1.1

# Initialize Kubernetes cluster
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# Set up kubeconfig for the current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Deploy Calico for networking
kubectl apply -f https://docs.projectcalico.org/v3.20/manifests/calico.yaml

# Deploy Nginx Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.49.0/deploy/static/provider/baremetal/deploy.yaml

# Download and install kubeaudit
sudo wget https://github.com/Shopify/kubeaudit/releases/download/v0.22.1/kubeaudit_0.22.1_linux_amd64.tar.gz
sudo tar -xvzf kubeaudit_0.22.1_linux_amd64.tar.gz
sudo mv kubeaudit /usr/local/bin/

# Run kubeaudit to check cluster configuration
kubeaudit all check
