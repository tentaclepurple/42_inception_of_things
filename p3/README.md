Install dependencies in vm

Create and config cluster

Create namespaces

Config argo credentials and launch argo server (default username and generated pass)

Create and push manifests to repo

Go to argo interface

    - new app


    S- General:

    Application Name: my-app (or whatever)
    Project: default
    Sync Policy: "Automatic"
    If namespace exist leave "Auto-create namespace" unchecked

    - Source:

    Repository URL: https://github.com/tentaclepurple/42_inception_of_things_imontero
    Revision: HEAD (main branch, normaly "main" o "master", during dev, "imontero" branch)
    Path: p3/manifests

    - Destination:

    Cluster URL: https://kubernetes.default.svc
    Namespace: dev



temp port-forward for tests:

    kubectl port-forward --address 0.0.0.0 svc/app-service -n dev 8889:8888

and access in browser:

    http://192.168.56.110:8889/

but since we have ingress, we can use just:

    http://192.168.56.110
