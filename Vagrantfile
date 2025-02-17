# Configuración de directorios
USER = ENV['USER']
VM_PATH = "/sgoinfre/students/#{USER}/VirtualBox VMs"

puts "================================================"
puts "Configurando Vagrant:"
puts "Usuario: #{USER}"
puts "Directorio VM: #{VM_PATH}"
puts "================================================"

Vagrant.configure("2") do |config|
  # Usando Alpine Linux en lugar de Ubuntu
  config.vm.box = "generic/alpine38"
  config.vm.network "forwarded_port", guest: 22, host: 2222
  # Configuración de VirtualBox
  config.vm.provider "virtualbox" do |vb|
    # Configuración mínima para SSH
    vb.memory = "512"
    vb.cpus = 1
    vb.name = "alpine_#{USER}"
    vb.gui = true
    # Directorio de la máquina
    vb.customize ["setproperty", "machinefolder", VM_PATH]
  end

  # Configuración SSH
  config.ssh.insert_key = true
  config.ssh.forward_agent = true
end