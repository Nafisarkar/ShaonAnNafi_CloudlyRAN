# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # base
  config.vm.box = "bento/ubuntu-22.04"
  config.vm.box_version = "202510.26.0"
  config.vm.network "forwarded_port", guest: 9999, host: 9999

  # vm resources config
  config.vm.provider "vmware_desktop" do |vb|
    vb.cpus = 2
    vb.memory = "4096"
    vb.ssh_info_public = true
  end


  # provisioning
  config.vm.provision "shell", path: "./scripts/setup_dependencies.sh"
  config.vm.provision "shell", path: "./scripts/build_open5gs.sh"
end
