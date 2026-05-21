  # -*- mode: ruby -*-
  # vi: set ft=ruby :

  Vagrant.configure("2") do |config|

    # base
    config.vm.box = "bento/ubuntu-22.04"
    config.vm.box_version = "202510.26.0"
    config.vm.network "forwarded_port", guest: 9999, host: 8080

    # This creates the 10.10.0.x interface for Open5GS
    config.vm.network "private_network", ip: "10.10.0.2"
    # This creates the 10.11.0.x interface for srsRAN
    config.vm.network "private_network", ip: "10.11.0.2"


    # vm resources config
    config.vm.provider "vmware_desktop" do |vb|
      vb.cpus = 2
      vb.memory = "4096"
      vb.ssh_info_public = true
    end


    # provisioning
    config.vm.provision "shell", path: "./scripts/setup_dependencies.sh"
    config.vm.provision "shell", path: "./scripts/build_open5gs.sh"
    config.vm.provision "shell", path: "./scripts/build_srsran.sh"
    config.vm.provision "shell", path: "./configs/open5gs/configure_open5gs.sh"
    config.vm.provision "shell", path: "./configs/srsran/configure_srsRAN.sh"
  end
