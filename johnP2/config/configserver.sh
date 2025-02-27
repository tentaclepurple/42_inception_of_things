#!/bin/bash

sudo ip link set eth1 up
sudo ip addr add 192.168.56.110/24 dev eth1
sudo apk add curl

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --node-ip 192.168.56.110 --bind-address=192.168.56.110" sh -s -

sleep 18

echo "export KUBECONFIG=/vagrant/k3s.yaml" >> ~/.bashrc
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
kubectl apply -f /vagrant/apps/app-1.yml --validate=false
kubectl apply -f /vagrant/apps/app-2.yml --validate=false
kubectl apply -f /vagrant/apps/app-3.yml --validate=false
kubectl apply -f /vagrant/apps/ingress.yml --validate=false
