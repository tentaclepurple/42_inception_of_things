# Kubernetes Core Concepts

## Cluster

A Kubernetes cluster is the foundation of the entire system. It consists of a set of machines (physical or virtual) that work together to run containerized applications. The cluster maintains application availability and scalability by distributing workloads across its components.
A cluster includes:

One or more control plane nodes that manage the cluster
Multiple worker nodes where applications actually run
Networking infrastructure that allows all components to communicate

Think of a cluster as a coordinated fleet of ships, each with specific roles but working toward a common goal.


## Nodes

Nodes are the individual machines (physical servers or VMs) that form your Kubernetes cluster. They provide the computing resources (CPU, memory, storage) needed to run containerized applications.
Two main types of nodes exist:

Control plane nodes: Manage the cluster state and make global decisions (scheduling, detecting failures, etc.)
Worker nodes: Run the actual application workloads

Each node runs several components:

kubelet: Ensures containers are running in a Pod
kube-proxy: Maintains network rules for service communication
Container runtime: Software responsible for running containers (like Docker or containerd)

Worker nodes are like the factory floor where production happens, while control plane nodes are the management offices overseeing operations.


## Pods

Pods are the smallest deployable units in Kubernetes. A Pod represents a single instance of a running process in your cluster and encapsulates:

One or more containers
Storage resources
A unique network IP
Options governing how the container(s) should run

Containers within a Pod:

Share the same network namespace (IP and port space)
Can communicate via localhost
Can share storage volumes

Pods are ephemeral by nature – they don't survive failures, scaling operations, or node maintenance. When a Pod dies, Kubernetes creates a new one to replace it, often with a different IP address.
Pods are like apartments in a building – they contain the actual living spaces (containers) and provide shared resources (networking, storage) for everything inside them.
ReplicaSets
A ReplicaSet ensures that a specified number of Pod replicas are running at any given time. It creates and manages Pods based on a template, replacing any that fail or are deleted.
ReplicaSets provide:

Self-healing capabilities (automatically replacing failed Pods)
Horizontal scaling (increasing or decreasing the number of identical Pods)
The foundation for higher-level resources like Deployments

While you can use ReplicaSets directly, they're most often managed by Deployments, which provide additional capabilities like rolling updates.


## Services

Services provide a stable networking endpoint to access a group of Pods. Since Pods are ephemeral and their IP addresses change, Services offer:

A consistent DNS name
A stable IP address (ClusterIP)
Load balancing across all matching Pods

Services use label selectors to identify the Pods they should route traffic to, creating a flexible, loosely-coupled architecture.
Think of a Service as a receptionist at a company – regardless of which employees come and go or move desks, the receptionist always knows how to direct calls to the right department.


## Ingress

Ingress manages external access to Services within the cluster, typically handling HTTP and HTTPS traffic. It provides:

URL routing based on paths or hostnames
SSL/TLS termination
Name-based virtual hosting

Ingress works alongside an Ingress Controller (like NGINX, Traefik, or HAProxy) that actually implements the rules defined in Ingress resources.
Ingress is like the main entrance of a large building with a directory that guides visitors to different offices based on where they want to go.


## Namespaces

Namespaces provide a mechanism for isolating groups of resources within a single cluster. They help organize resources when many users or projects share the cluster.
Namespaces are useful for:

Resource isolation between teams or projects
Access control restrictions
Resource quota management
Organizing applications into logical groups

Most Kubernetes resources (such as Pods, Services, Deployments) belong to a specific namespace, though some are cluster-wide and not namespaced.
Namespaces are similar to different departments in a company, each with their own resources, rules, and areas of responsibility, but all part of the same organization.


## ConfigMaps and Secrets

These resources help separate configuration from application code:
ConfigMaps store non-confidential configuration data as key-value pairs, which can be:

Used as environment variables
Mounted as files in a volume
Used in command-line arguments

Secrets are similar to ConfigMaps but designed to hold sensitive information like:

Passwords
OAuth tokens
TLS certificates

Both allow you to change configuration without rebuilding your application container images.


## Persistent Volumes

Persistent Volumes (PVs) provide storage resources that outlive the lifecycle of any individual Pod. They allow data to persist even when Pods are deleted and recreated.
The storage workflow typically involves:

PersistentVolume: Represents a piece of storage provisioned by an administrator
PersistentVolumeClaim: A request for storage by a user
StorageClass: Defines how storage is provisioned dynamically

This architecture separates storage concerns from application deployment, allowing different teams to manage each aspect independently.