#!/bin/bash

#wget https://raw.githubusercontent.com/tentaclepurple/42_inception_of_things/main/setup_vm.sh

echo "Installing requirements for Inception of Things (Debian version)..."

# Update system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install basic tools
echo "Installing basic tools..."
sudo apt install -y curl wget git micro make gnupg2 apt-transport-https ca-certificates software-properties-common

# Install Docker
echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install K3d
echo "Installing K3d..."
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Install K3s
echo "Installing K3s..."
curl -sfL https://get.k3s.io | sh -

# Install VirtualBox (for Debian)
echo "Installing VirtualBox..."
echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo apt update
sudo apt install -y virtualbox-6.1

# Install Vagrant
echo "Installing Vagrant..."
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install -y vagrant

# Install Helm (needed for GitLab installation)
echo "Installing Helm..."
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt update
sudo apt install -y helm

# Install GitLab dependencies
echo "Installing GitLab dependencies..."
sudo apt install -y postgresql postgresql-contrib redis-server

echo "Installation completed!"
echo "Please log out and log back in for docker group changes to take effect."

# Verify installations
echo "Verifying installations..."
echo "Docker version:"
docker --version
echo "kubectl version:"
kubectl version --client
echo "K3d version:"
k3d version
echo "Vagrant version:"
vagrant --version
echo "Helm version:"
helm version