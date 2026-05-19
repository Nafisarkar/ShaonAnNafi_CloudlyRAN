# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # base
  config.vm.box = "ubuntu/jammy64"
  config.vm.box_version = "20241002.0.0"

  # network
  config.vm.network "private_network", ip: "192.168.56.10"

  # vm resources config
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 2
    vb.memory = "2048"
  end


  # provisioning
  config.vm.provision "shell", path: "./scripts/setup_dependencies.sh"
end
