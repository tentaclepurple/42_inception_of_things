k3d cluster create argocd-cluster --api-port 6443 -p "8888:8888@loadbalancer" -p "80:80@loadbalancer" -p "443:443@loadbalancer"

mkdir -p $HOME/.kube
k3d kubeconfig get argocd-cluster > $HOME/.kube/config
chmod 600 $HOME/.kube/config

kubectl create namespace argocd
kubectl create namespace dev

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sleep 60
echo "Waiting for ArgoCD to start..."

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > argopass

echo "ArgoCD interface:  https://192.168.56.110:8080"

kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443
