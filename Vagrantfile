# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Utilizamos Ubuntu 20.04 LTS como sistema base por su estabilidad y soporte
  config.vm.box = "ubuntu/focal64"
  
  # Establecemos el nombre de la máquina
  config.vm.hostname = "iot-host"
  
  # Configuramos una red privada con IP estática
  # Esta IP será accesible desde tu máquina host
  config.vm.network "private_network", ip: "192.168.56.10"

  # Configuración específica para VirtualBox
  config.vm.provider "virtualbox" do |vb|
    # Habilitamos la interfaz gráfica
    vb.gui = true
    
    # Nombre de la máquina en VirtualBox
    vb.name = "IoT-Host-VM"
    
    # Asignamos recursos moderados pero suficientes
    vb.memory = "2048"  # 2GB RAM
    vb.cpus = 2
    
    # Configuración para soporte gráfico
    vb.customize ["modifyvm", :id, "--vram", "64"]
    vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
    
    # Habilitamos la virtualización anidada (necesaria para VMs dentro de esta VM)
    vb.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    
    # Configuraciones adicionales para mejorar el rendimiento
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
  end

  # Script de aprovisionamiento que se ejecuta al crear la máquina
  config.vm.provision "shell", privileged: true, inline: <<-SHELL
    # Actualizamos el sistema
    apt-get update
    apt-get upgrade -y

    # Instalamos el entorno de escritorio ligero LXDE y herramientas básicas
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      lxde-core \
      xorg \
      lightdm \
      firefox \
      curl \
      wget \
      git \
      vim

    # Configuramos el inicio de sesión automático
    mkdir -p /etc/lightdm/lightdm.conf.d
    cat > /etc/lightdm/lightdm.conf.d/12-autologin.conf << EOF
[SeatDefaults]
autologin-user=vagrant
autologin-user-timeout=0
EOF

    # Instalamos Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    usermod -aG docker vagrant

    # Instalamos VirtualBox
    apt-get install -y virtualbox

    # Instalamos Vagrant
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    apt-get update && apt-get install -y vagrant

    # Instalamos kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

    # Instalamos K3d
    wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

    # Limpiamos el sistema
    apt-get autoremove -y
    apt-get clean
  SHELL
end