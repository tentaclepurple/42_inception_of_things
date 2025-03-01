#!/bin/sh

# Update system packages
echo "Updating system packages..."
sudo apk update
sudo apk upgrade

# Install basic dependencies and Git
echo "Installing basic dependencies and Git..."
sudo apk add --no-cache ca-certificates curl git

# Install Docker
echo "Installing Docker..."
sudo apk add --no-cache docker
sudo rc-update add docker boot
sudo service docker start

# Configure Docker for the current user
echo "Configuring Docker permissions..."
sudo addgroup $USER docker
echo "NOTE: You MUST log out and log back in for the docker group permissions to take effect."

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

# Install K3d
echo "Installing K3d..."
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Install Helm
echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install necessary utilities
echo "Installing additional utilities..."
sudo apk add --no-cache jq bash bash-completion postgresql-client

# Install for better VM performance
echo "Installing additional packages for improved performance..."
sudo apk add --no-cache htop net-tools

echo "All dependencies installed successfully!"
echo "IMPORTANT: You need to log out and log back in (or restart the VM) for Docker permissions to take effect."