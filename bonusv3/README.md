Start both VMs

## 1st machine gitlab

It will launch gitlab instance

    http://192.168.56.111:9999/

Create repo

Add remote repository 

    git remote add <alias> <remote repo>

## 2nd machine argocd

Copy scripts 
    
    scp -r . iot@192.168.56.112:iot

Get into VM

    ssh iot@192.168.56.112

Install vm dependencies and setup cluster

    sudo chmod 777 *
    ./vmconfig.sh
    ./setup.sh

Enter argocd

    https://192.168.56.112:8080/
    

Config new app like in p3 (namespace gitlab) and start syncronizing

Try app

    http://192.168.56.112/

Go to gitlab repo, change to v2, commit and wait for app to being update




