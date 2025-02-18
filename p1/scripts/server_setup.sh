#!/bin/bash

# update
apt-get update
apt-get upgrade -y

apt-get install -y curl

# InstalL k3s in server mode
curl -sfL https://get.k3s.io | sh -

mkdir -p /vagrant/confs

# save token for worker
sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/confs/node-token

ls -la /vagrant/confs
cat /vagrant/confs/node-token

# Install kubectl (already comes with k3s but just in case)
if ! command -v kubectl &> /dev/null; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/
fi

# Config no password ssh
if [ ! -f /home/vagrant/.ssh/id_rsa ]; then
    sudo -u vagrant ssh-keygen -t rsa -N "" -f /home/vagrant/.ssh/id_rsa
fi