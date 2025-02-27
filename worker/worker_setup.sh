#!/bin/bash

sudo ip link set eth1 up
sudo ip addr add 192.168.56.111/24 dev eth1
sudo apk add curl

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --server https://192.168.56.110:6443 --token-file /vagrant/node-token --node-ip=192.168.56.111" sh -s -

echo "export KUBECONFIG=/vagrant/k3s.yaml" >> ~/.bashrc
export KUBECONFIG=/vagrant/k3s.yaml