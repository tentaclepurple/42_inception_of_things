Install dependencies in vm

Create and config cluster

Create namespaces

Config argo credentials and launch argo server (default username and generated pass)

Create and push manifests to repo

Go to argo interface

    - new app


    - General:

    Application Name: my-app (or whatever)
    Project: default
    Sync Policy: "Automatic"
    If namespace exist leave "Auto-create namespace" unchecked

    - Source:

    Repository URL: https://github.com/tentaclepurple/42_inception_of_things_imontero
    Revision: HEAD (main branch, normaly "main" o "master", during dev, "imontero" branch)
    Path: p3/manifests

    - Destination:

    Cluster URL: 
    Namespace: dev



temp port-forward for tests:

    kubectl port-forward --address 0.0.0.0 svc/app-service -n dev 8889:8888

and access in browser:

    http://192.168.56.110:8889/

but since we have ingress, we can use just:

    http://192.168.56.110

# K3d Overview

K3d is a lightweight wrapper that runs [K3s](https://k3s.io/) (Rancher's minimal Kubernetes distribution) in Docker containers. This tool makes it extremely easy to create, manage, and work with Kubernetes clusters on a local development machine.

## Key Features

- **Lightweight**: Requires minimal resources compared to other Kubernetes development solutions
- **Fast deployment**: Creates clusters in seconds rather than minutes
- **Docker-based**: Runs K3s nodes as Docker containers, eliminating the need for VMs
- **Multi-node support**: Easily create multi-node clusters with separate server and agent nodes
- **Registry integration**: Built-in support for local container registries
- **Port mapping**: Simple exposure of services to the host machine
- **Resource isolation**: Each cluster runs independently in its own Docker network

## Common Use Cases

- Local Kubernetes development environment
- CI/CD testing pipelines
- Learning and experimenting with Kubernetes
- GitOps workflow testing with tools like Argo CD
- Lightweight Kubernetes for resource-constrained environments

## Basic Commands

```bash
# Create a cluster
k3d cluster create my-cluster

# Create a cluster with specific settings
k3d cluster create my-cluster --servers 1 --agents 2 -p "8080:80@loadbalancer"

# List clusters
k3d cluster list

# Start/stop clusters
k3d cluster start my-cluster
k3d cluster stop my-cluster

# Delete a cluster
k3d cluster delete my-cluster

# Import local images into the cluster
k3d image import my-image:latest -c my-cluster
```

K3d provides a perfect balance between simplicity and functionality, making it an ideal choice for local Kubernetes development and testing.

