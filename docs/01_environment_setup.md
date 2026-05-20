## VMware Support for AVX Instruction Passthrough

- **Reason**: MongoDB 8.0 requires AVX
- **Steps**:
  - Install VMware
  - Install Vagrant VMware Utility: [vmware utility](https://developer.hashicorp.com/vagrant/install/vmware)
  - Install Vagrant plugin for VMware: `vagrant plugin install vagrant-vmware-desktop`

## Base Configuration

- Created default environment with `vagrant init`
- Set Ubuntu 22.04 as base

## Network Configuration

- Assigning static IP for VM: 192.168.56.10

## Resources Configuration

- Assigning 2 cores
- Assigning 2GB of RAM

## Provisioning

- Invoke: `setup_dependencies.sh`
- Invoke: `build_open5gs.sh`
- Invoke: `build_srsran.sh`
- Invoke: `configure_open5gs.sh`
