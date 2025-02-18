#!/bin/bash

# Update sys
apt-get update
apt-get upgrade -y
apt-get install -y curl


# Wait until token is available
while [ ! -f /vagrant/confs/node-token ]; do
    echo "Waiting for server token..."
    sleep 5
done

# Get token from server
NODE_TOKEN=$(cat /vagrant/confs/node-token)

# Install k3s in agent mode
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=${NODE_TOKEN} sh -

# Config no password ssh
if [ ! -f /home/vagrant/.ssh/id_rsa ]; then
    sudo -u vagrant ssh-keygen -t rsa -N "" -f /home/vagrant/.ssh/id_rsa
fi