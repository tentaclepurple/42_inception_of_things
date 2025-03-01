#!/bin/bash
set -e

echo "=== CLEANING UP GITLAB AND ARGO CD ENVIRONMENT ==="

# Check if cluster exists
if ! k3d cluster list | grep -q "gitlab-cluster"; then
  echo "Cluster 'gitlab-cluster' does not exist. Nothing to clean up."
  exit 0
fi

# Configure kubectl to use the cluster
echo "Configuring kubectl..."
k3d kubeconfig get gitlab-cluster > ~/.kube/config
chmod 600 ~/.kube/config

# Uninstall GitLab
echo "Uninstalling GitLab..."
if helm list -n gitlab | grep -q "gitlab"; then
  helm uninstall gitlab -n gitlab
  echo "Waiting for GitLab resources to be cleaned up..."
  sleep 10
fi

# Delete persistent volume claims
echo "Deleting GitLab persistent volume claims..."
kubectl delete pvc --all -n gitlab 2>/dev/null || true

# Uninstall Argo CD
echo "Uninstalling Argo CD..."
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml 2>/dev/null || true

# Delete namespaces
echo "Deleting namespaces..."
kubectl delete namespace gitlab --wait=false 2>/dev/null || true
kubectl delete namespace argocd --wait=false 2>/dev/null || true
kubectl delete namespace dev --wait=false 2>/dev/null || true

# Give some time for namespace deletion to start
echo "Waiting for namespace deletion to start..."
sleep 5

# Delete the entire K3d cluster
echo "Deleting K3d cluster 'gitlab-cluster'..."
k3d cluster delete gitlab-cluster

# Clean up credential files
echo "Removing credential files..."
rm -f argocd-password gitlab-password 2>/dev/null || true

echo "=== CLEANUP COMPLETED ==="
echo "All resources have been deleted."