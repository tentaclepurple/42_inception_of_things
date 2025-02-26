#!/bin/bash

apk add curl

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --node-ip $1 --bind-address=$1" sh -s -

sleep 18

kubectl apply -n kube-system -f /vagrant/apps/app-1.yml --validate=false
kubectl apply -n kube-system -f /vagrant/apps/app-2.yml --validate=false
kubectl apply -n kube-system -f /vagrant/apps/app-3.yml --validate=false
kubectl apply -n kube-system -f /vagrant/apps/ingress.yml --validate=false
