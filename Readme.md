## Inception of Things

Si durante la conexion por el SSH falla se aplica esto:
ssh-keygen -f "/home/$USER/.ssh/known_hosts" -R "[localhost]:2222"

## Para sincronizar la carpeta de trabajo con la VM. (PC42)
sudo modprobe vboxsf
sudo mkdir -p /vagrant
sudo mount -t vboxsf -o uid=1000,gid=1000 vagrant /vagrant
echo "vagrant /vagrant vboxsf uid=1000,gid=1000 0 0" | sudo tee -a /etc/fstab

## Asignar la ip o activarla en la eth1:
sudo ip addr add 192.168.56.110/24 dev eth1 #server
sudo ip addr add 192.168.56.111/24 dev eth1 #worker

kubeconfig

sudo systemctl status k3s #alpine: sudo rc-service k3s status
sudo systemctl status k3s-agent
sudo chmod 644 /etc/rancher/k3s/k3s.yaml

sudo ip addr add 192.168.56.110/24 dev eth1