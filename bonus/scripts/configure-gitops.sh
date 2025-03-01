#!/bin/bash
set -e

echo "=== CONFIGURING GITOPS WITH GITLAB AND ARGO CD ==="

GITLAB_URL="http://192.168.56.111:8080"
GITLAB_USER="root"
GITLAB_PASSWORD=$(cat gitlab-password)
PROJECT_NAME="k8s-app"
APP_NAME="myapp"

# 1. Configure GitLab access
echo "Configuring GitLab access..."
# Create personal access token in GitLab
TOKEN=$(curl -s --data "grant_type=password&username=${GITLAB_USER}&password=${GITLAB_PASSWORD}" \
    "${GITLAB_URL}/oauth/token" | jq -r .access_token)

# 2. Create project in GitLab
echo "Creating project in GitLab..."
curl -s --header "Authorization: Bearer ${TOKEN}" \
     --data "name=${PROJECT_NAME}&visibility=public" \
     "${GITLAB_URL}/api/v4/projects"

# 3. Clone repository locally
echo "Cloning repository..."
git config --global user.email "admin@example.com"
git config --global user.name "Admin"
REPO_URL="${GITLAB_URL}/${GITLAB_USER}/${PROJECT_NAME}.git"
mkdir -p /tmp/gitops-app
cd /tmp/gitops-app
git init
git remote add origin "${REPO_URL}"

# 4. Create manifests
echo "Creating application manifests..."
mkdir -p manifests
cp /vagrant/bonus/confs/app-manifests/* manifests/

# 5. Add manifests to repository and push
echo "Adding manifests to repository..."
git add .
git commit -m "Add initial application manifests"
git push --set-upstream origin master -f

# 6. Configure Argo CD
echo "Configuring Argo CD..."
ARGOCD_PASSWORD=$(cat argocd-password)

# Login to Argo CD
argocd login localhost:8081 --username admin --password "${ARGOCD_PASSWORD}" --insecure

# Add repository to Argo CD
argocd repo add "${REPO_URL}" --username "${GITLAB_USER}" --password "${GITLAB_PASSWORD}"

# Create application in Argo CD
argocd app create ${APP_NAME} \
  --repo "${REPO_URL}" \
  --path manifests \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace dev \
  --sync-policy automated

echo "=== GITOPS CONFIGURATION COMPLETED ==="
echo "The application ${APP_NAME} has been configured to automatically sync from GitLab."
echo "You can test the GitOps cycle by making a change in the GitLab repository."
echo ""
echo "To test an update, you can change the image version:"
echo "1. Edit the deployment.yaml file in the GitLab repository"
echo "2. Change 'wil42/playground:v1' to 'wil42/playground:v2'"
echo "3. Argo CD will detect the change and automatically update the application"