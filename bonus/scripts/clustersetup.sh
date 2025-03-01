#!/bin/bash

echo "=== SETTING UP ENVIRONMENT FOR GITLAB AND ARGO CD ==="

k3d cluster create gitlab-cluster \
  --api-port 6443 \
  --agents 1 \
  --port "8080:80@loadbalancer" \
  --port "8443:443@loadbalancer" \
  --port "8929:8929@loadbalancer" \
  --k3s-arg "--disable=traefik@server:0"

mkdir -p $HOME/.kube
k3d kubeconfig get gitlab-cluster > $HOME/.kube/config
chmod 600 $HOME/.kube/config

kubectl create namespace gitlab
kubectl create namespace argocd
kubectl create namespace dev

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sleep 12

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > argocd-password

helm repo add gitlab https://charts.gitlab.io/
helm repo update

helm install gitlab gitlab/gitlab \
  --set global.hosts.domain=192.168.56.111.nip.io \
  --set global.ingress.class=nginx \
  --set global.ingress.enabled=true \
  --set global.ingress.useGlobalIngress=false \
  --set certmanager.install=false \
  --set prometheus.install=false \
  --set gitlab-runner.install=false \
  --set gitlab.gitaly.persistence.size=500Mi \
  --set postgresql.persistence.size=500Mi \
  --set redis.master.persistence.size=250Mi \
  --set minio.persistence.size=250Mi \
  --set global.pages.enabled=false \
  --set global.praefect.enabled=false \
  --set global.kas.enabled=false \
  --set global.grafana.enabled=false \
  --set global.appConfig.cron_jobs=null \
  --set registry.enabled=false \
  --set certmanager-issuer.email=admin@example.com \
  --namespace gitlab

sleep 300

#kubectl get pods -n gitlab

kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 -d > gitlab-password
cat gitlab-password

kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8081:443 &

