# Kubernetes Cluster with K3s

This project sets up a simple Kubernetes cluster using K3s on Alpine Linux virtual machines managed by Vagrant.

## Architecture

The cluster consists of:
- 1 server node (master): `imonteroS` with IP 192.168.56.110
- 1 worker node: `imonteroSW` with IP 192.168.56.111

## Requirements

- VirtualBox
- Vagrant

## Getting Started

1. Navigate to the p1 directory
2. Run `vagrant up` to create and provision both VMs
3. Connect to the server node with `vagrant ssh imonteroS`
4. Verify the cluster is working with `kubectl get nodes`

## Vagrant Commands

- Start the VMs: `vagrant up`
- Stop the VMs: `vagrant halt`
- Destroy the VMs: `vagrant destroy`
- SSH into server: `vagrant ssh imonteroS`
- SSH into worker: `vagrant ssh imonteroSW`

## Notes

- Each VM has 1GB of memory (minimum recommended for K3s)
- The shared folder `/vagrant` contains the node token for cluster communication
- If you experience issues, check K3s logs with `sudo cat /var/log/k3s.log`

<br>

    Vagrant.configure("2") do |config|

        config.vm.box = "generic/alpine317"        # Set the base box to Alpine Linux 3.17
            
        config.vm.provider "virtualbox" do |virtualbox|   # Configure VirtualBox provider settings
           
            virtualbox.memory = 1024   # Allocate 1024MB of RAM to each VM
            virtualbox.cpus = 1   # Assign 1 CPU core to each VM
        end
        
        config.vm.define "imonteroS" do |server|                        # Define the Kubernetes server node (master)
            server.vm.hostname = "imonteroS"                            # Set hostname for the server VM
            server.vm.network "private_network", ip: "192.168.56.110"   # Configure a private network with static IP
            server.vm.synced_folder ".", "/vagrant"                     # Mount the project directory to /vagrant in the VM
            server.vm.provision "shell", privileged: true, path: "config/server.sh", args: ["192.168.56.110"]      # Run the server provisioning script with the server IP as an argument

        end
        
        config.vm.define "imonteroSW" do |worker|                        # Define the Kubernetes worker node
            worker.vm.hostname = "imonteroSW"                            # Set hostname for the worker VM
            worker.vm.network "private_network", ip: "192.168.56.111"    # Configure a private network with static IP
            worker.vm.synced_folder ".", "/vagrant"                      # Mount the project directory to /vagrant in the VM
            worker.vm.provision "shell", privileged: true, path: "config/worker.sh", args: ["192.168.56.110", "192.168.56.111"]           # Run the worker provisioning script with both server and worker IPs as arguments
        end
    end


<br>

    #!/bin/bash

    # Install curl
    apk add curl

    # Download and install K3s with the following parameters:
    # --write-kubeconfig-mode=644: Set kubeconfig file permissions to 644 (readable by all users)
    # --node-ip $1: Set the node IP to the first script argument (192.168.56.110)
    # --bind-address=$1: Bind the K3s API server to the specified IP address

    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --node-ip $1 --bind-address=$1" sh -s -


    sleep 18  # Wait for K3s to fully initialize and generate node token

    # Copy the node token to the shared /vagrant directory
    # This token will be used by worker nodes to join the cluster

    cp /var/lib/rancher/k3s/server/node-token /vagrant/.


<br>


    #!/bin/bash
    apk add curl    # Install curl


    # Download and install K3s in agent mode with the following parameters:
    # agent: Run K3s as an agent (worker) node
    # --server https://$1:6443: Connect to the K3s server at the specified IP and port
    #                          (first script argument, 192.168.56.110)
    # --token-file /vagrant/node-token: Use the node token from the shared directory
    #                                  for authentication with the server
    # --node-ip=$2: Set the worker node IP to the second script argument (192.168.56.111)

    curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --server https://$1:6443 --token-file /vagrant/node-token --node-ip=$2" sh -s -

<br>