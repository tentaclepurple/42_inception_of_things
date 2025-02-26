### used app

    https://hub.docker.com/r/paulbouwer/hello-kubernetes/



### tests

default app-3 http://192.168.56.110


app-1 

    curl -H "Host: app-1.com" http://192.168.56.110


app-2

    curl -H "Host: app-2.com" http://192.168.56.110


test cluster

    kubectl get nodes -o wide 

    kubectl get all

    kubectl get all -n kube-system


drop node to test replicas

    kubectl scale deployment -n kube-system app-2 --replicas=0




# app manifests


### Deployments

A Deployment is a Kubernetes resource that provides declarative updates for Pods and ReplicaSets. Deployments allow you to:

- Define your desired application state
- Change the application state from the current state to the desired state at a controlled rate
- Roll back to previous deployment versions
- Scale the application by increasing or decreasing the number of replicas

Deployments manage the creation and updating of Pods through ReplicaSets, ensuring the specified number of Pod replicas are running at all times. If a Pod fails or is terminated, the Deployment controller replaces it automatically.

Key fields in a Deployment manifest:

- `replicas`: Number of identical Pods to maintain
- `selector`: How the Deployment identifies which Pods to manage
- `template`: Blueprint for the Pods the Deployment creates
- `strategy`: How to replace old Pods with new ones during updates (RollingUpdate or Recreate)

Deployments are ideal for stateless applications where any Pod can handle requests and no persistent local state is required.

### Services

A Service is an abstraction that defines a logical set of Pods and a policy to access them. As Pods are ephemeral (they can be created, destroyed, and moved between nodes), their IP addresses change. Services solve this problem by providing:

- A stable endpoint (name and IP address) that remains constant regardless of changes to the underlying Pods
- Load balancing of traffic across all available Pods
- Service discovery through DNS or environment variables
- A consistent way to expose applications to clients inside or outside the cluster

Types of Services:

- **ClusterIP**: Exposes the Service on an internal IP within the cluster (default)
- **NodePort**: Exposes the Service on the same port of each selected Node in the cluster
- **LoadBalancer**: Exposes the Service externally using a cloud provider's load balancer
- **ExternalName**: Maps the Service to the contents of the externalName field by returning a CNAME record

The connection between Services and Pods is established through Labels and Selectors. Services use selectors to target Pods with matching labels.

### Services and Deployments Relationship

Services and Deployments work together but serve different purposes:

1. Deployments manage the lifecycle of Pods (creation, updating, scaling)
2. Services provide network access to those Pods

This separation of concerns allows:

- Updating Pods (through Deployments) without disrupting how clients access them
- Scaling applications up or down without changing access points
- Seamless rollbacks that are transparent to clients

The same label selectors that Deployments use to manage Pods are used by Services to direct traffic to those Pods, creating a loosely coupled but functional architecture.

In typical Kubernetes applications, you'll create both a Deployment (to manage your application's Pods) and a Service (to provide network access to those Pods) as demonstrated in our example applications.


