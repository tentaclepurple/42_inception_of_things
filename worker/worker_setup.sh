#!/bin/bash

# Update sys
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y curl
sudo apt install -y iptables iptables-persistent
sudo apt install -y ip6tables ip6tables-persistent
sudo ip addr add 192.168.56.111/24 dev eth1

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