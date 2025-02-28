#!/bin/bash

sudo ip link set eth1 up
sudo ip addr add 192.168.56.110/24 dev eth1

# Update system packages
echo "Updating system packages..."
sudo apt-get update
sudo apt-get upgrade -y

# Install basic dependencies and Git
echo "Installing basic dependencies and Git..."
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release git

# Install Docker
echo "Installing Docker..."
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Configure Docker for the current user and start the service
echo "Configuring Docker permissions..."
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker
echo "NOTE: You MUST log out and log back in for the docker group permissions to take effect."

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# Install K3d
echo "Installing K3d..."
curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash

echo "All dependencies installed successfully!"
echo "IMPORTANT: You need to log out and log back in (or restart the VM) for Docker permissions to take effect."