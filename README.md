# CloudlyRAN - 5G Network Simulation

A complete 5G network simulation environment combining **srsRAN** (radio access network) and **Open5GS** (5G core network) running in a Vagrant VM with Ubuntu 22.04.

## Architecture

```
+-------------------------------------------------------------------------+
|                              Host Machine                               |
|                                                                         |
|  +-------------------------------------------------------------------+  |
|  |                    Vagrant VM (Ubuntu 22.04)                      |  |
|  |                                                                   |  |
|  |   +-----------------------+           +-----------------------+   |  |
|  |   |    srsRAN Project     |           |        Open5GS        |   |  |
|  |   |    (Radio Network)    |           |       (5G Core)       |   |  |
|  |   |                       |           |                       |   |  |
|  |   |      +---------+      |   NGAP    |      +---------+      |   |  |
|  |   |      |   gNB   |=========================|   AMF   |      |   |  |
|  |   |      +---------+      |  (SCTP)   |      +---------+      |   |  |
|  |   |           |           |           |           |           |   |  |
|  |   |    (ZeroMQ for RF)    |           |      +---------+      |   |  |
|  |   |                       |           |      | UPF/SMF |      |   |  |
|  |   +-----------------------+           |      +---------+      |   |  |
|  |                                       +-----------------------+   |  |
|  +-------------------------------------------------------------------+  |
+-------------------------------------------------------------------------+
```

## Overview

This project simulates a complete 5G network stack:

- **srsRAN gNB (gNodeB)**: Radio access network component handling RF simulation via ZeroMQ
- **Open5GS 5G Core**: Complete 5G service-based architecture including AMF, SMF, UPF, and other network functions
- **NGAP Protocol**: Communication between gNB and AMF over SCTP
- **MongoDB**: Database backend for Open5GS

## Prerequisites

### System Requirements

- **VMware** or another virtualization provider with AVX instruction support (required for MongoDB 8.0)
- **Vagrant** installed
- **Vagrant plugin** for your hypervisor:
  - For VMware: `vagrant plugin install vagrant-vmware-desktop`
  - For VirtualBox: No additional plugin needed (but AVX may not be supported)

### Hardware Specifications

The Vagrant configuration provides:
- **2 CPU cores**
- **2GB RAM**
- **Static IP**: 192.168.56.10 (Ubuntu 22.04)

