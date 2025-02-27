Install dependencies in vm

Create and config cluster

Create namespaces

Config argo credentials and launch argo server (default username and generated pass)

Create and push manifests to repo

Go to argo interface

    - new app






temp port-forward for tests:

    kubectl port-forward --address 0.0.0.0 svc/app-service -n dev 8889:8888

and access in browser:

    http://192.168.56.110:8889/

but since we have ingress, we can use just:

    http://192.168.56.110
