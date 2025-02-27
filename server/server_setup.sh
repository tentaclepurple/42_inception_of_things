#!/bin/bash

sudo ip link set eth1 up
sudo ip addr add 192.168.56.110/24 dev eth1
sudo apk add curl
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --node-ip 192.168.56.110 --bind-address=192.168.56.110" sh -s -

sleep 18

sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/.
sudo cp /etc/rancher/k3s/k3s.yaml /vagrant/k3s.yaml
sudo chmod 644 /vagrant/k3s.yaml
sudo sed -i 's/127.0.0.1/192.168.56.110/g' /vagrant/k3s.yaml