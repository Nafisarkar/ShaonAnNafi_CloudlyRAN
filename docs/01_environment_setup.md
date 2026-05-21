## Prerequisites

- **VMware** (required for AVX passthrough — MongoDB 8.0 needs AVX)
- **Vagrant + Vagrant VMware Utility**: [download](https://developer.hashicorp.com/vagrant/install/vmware)
- Install plugin: `vagrant plugin install vagrant-vmware-desktop`

## VM Specs

| Item          | Value                               |
|---------------|-------------------------------------|
| Box           | `bento/ubuntu-22.04` (202510.26.0)  |
| vCPU          | 2                                   |
| RAM           | 4 GB                                |
| Disk          | 50 GB                               |

## Network

| Interface    | IP               | Purpose                     |
|--------------|------------------|-----------------------------|
| Private #1   | `10.10.0.2`      | Control Plane (NGAP/S1AP)   |
| Private #2   | `10.11.0.2`      | User Plane (GTPU)           |
| Forwarded    | `9999` → `9999`  | WebUI / debug               |

## Provisioning Flow

1. **`scripts/setup_dependencies.sh`** — Installs MongoDB 8.0, Node.js 20, build tools (meson, ninja, cmake, etc.), configures TUN/ NAT, disables firewall.
2. **`scripts/build_open5gs.sh`** — Builds and installs Open5GS.
3. **`scripts/build_srsran.sh`** — Builds and installs srsRAN.
4. **`configs/open5gs/configure_open5gs.sh`** — Configures Open5GS components.
5. **`configs/srsran/configure_srsRAN.sh`** — Configures srsRAN gNB.

## Quick Start

```bash
vagrant up
vagrant ssh
```
