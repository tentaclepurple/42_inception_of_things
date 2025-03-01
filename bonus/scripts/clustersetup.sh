#!/bin/bash
set -e

echo "=== SETTING UP ENVIRONMENT FOR GITLAB AND ARGO CD ==="

# Create K3d cluster
echo "Creating K3d cluster for GitLab..."
k3d cluster create gitlab-cluster \
  --api-port 6443 \
  --agents 2 \
  --port "8080:80@loadbalancer" \
  --port "8443:443@loadbalancer" \
  --port "8929:8929@loadbalancer"

# Configure kubectl
mkdir -p $HOME/.kube
k3d kubeconfig get gitlab-cluster > $HOME/.kube/config
chmod 600 $HOME/.kube/config

# Create namespaces
echo "Creating required namespaces..."
kubectl create namespace gitlab
kubectl create namespace argocd
kubectl create namespace dev

# Install Argo CD
echo "Installing Argo CD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for Argo CD to be ready
echo "Waiting for Argo CD to become available..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

# Save Argo CD credentials
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > argocd-password
echo "Argo CD password has been saved to 'argocd-password'"

# Install Helm and add GitLab repository
echo "Configuring Helm for GitLab..."
helm repo add gitlab https://charts.gitlab.io/
helm repo update

# Install GitLab
echo "Installing GitLab (this may take several minutes)..."
helm install gitlab gitlab/gitlab -f ~/iot/bonus/confs/gitlab-values.yml -n gitlab

# Wait for GitLab to be available (may take up to 10 minutes)
echo "Waiting for GitLab to become available (this may take up to 10 minutes)..."
kubectl wait --for=condition=available deployment/gitlab-webservice-default -n gitlab --timeout=600s

# Get GitLab credentials
echo "Retrieving GitLab credentials..."
kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -o jsonpath="{.data.password}" | base64 -d > gitlab-password
echo "GitLab root password has been saved to 'gitlab-password'"

echo "=== SETUP COMPLETED ==="
echo "Argo CD credentials:"
echo "  Username: admin"
echo "  Password: $(cat argocd-password)"
echo ""
echo "GitLab credentials:"
echo "  Username: root"
echo "  Password: $(cat gitlab-password)"
echo ""
echo "To access GitLab: http://192.168.56.111:8080"
echo "To access Argo CD: https://localhost:8081 (after running port-forward)"
echo ""
echo "Run the following to access Argo CD:"
echo "  kubectl port-forward svc/argocd-server -n argocd 8081:443"