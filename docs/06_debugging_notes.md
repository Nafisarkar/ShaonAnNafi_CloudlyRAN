## Issue 1: VBoxManage Access Denied Error

**Error:**
```
VBoxManage.exe: error: Details: code E_ACCESSDENIED (0x80070005), component MachineWrap, interface IMachine, callee IUnknown
VBoxManage.exe: error: Context: "LockMachine(a->session, LockType_Shared)" at line 3328 of file VBoxManageInfo.cpp
```

**Explanation:** Caused by trying to access a Virtual Machine (VM) that is already locked by another process or an orphaned session.

**Fix:**
- Remove Inaccessible VMs
- Restart Virtual Box
- Restart host

## Issue 2: MongoDB Core Dump Error

**Error:**
```
Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
Active: failed (Result: core-dump) since Tue 2026-05-19 12:06:16 UTC; 14s ago
  Docs: https://docs.mongodb.org/manual
Process: 5142 ExecStart=/usr/bin/mongod --config /etc/mongod.conf (code=dumped, signal=ILL)
Main PID: 5142 (code=dumped, signal=ILL)
     CPU: 11ms

May 19 12:06:16 ubuntu-jammy systemd[1]: Started MongoDB Database Server.
May 19 12:06:16 ubuntu-jammy systemd[1]: mongod.service: Main process exited, code=dumped, status=4/ILL
May 19 12:06:16 ubuntu-jammy systemd[1]: mongod.service: Failed with result 'core-dump'.
```

**Explanation:** VM's CPU does not support instructions required by MongoDB 8.0. With Ryzen 3600, Virtual Box can't pass through AVX with the Virtual Box provider.

**Reference:** [More About This Error](https://www.mongodb.com/community/forums/t/setting-up-mongodb-v5-0-on-ubuntu-20-core-dump-status-4-ill/120705)

**Note:** If we install MongoDB 4.4, we have to switch to Ubuntu 20.

**Fix:**
- Either use MongoDB 4.4 last version that does not require AVX
- Use other provider (Docker/VMware):
  - **VMware:**
    1. Install VMware
    2. Install Vagrant VMware Utility: [vmware utility](https://developer.hashicorp.com/vagrant/install/vmware)
    3. Install Vagrant plugin for VMware

## Issue 3: Configuration File Parse Error

**Error:**
```
default: 05/20 13:17:14.889: [app] FATAL: Failed to parse configuration file '/home/vagrant/open5gs/install/etc/open5gs/mme.yaml' (../lib/app/ogs-init.c:199)
default: 05/20 13:17:14.889: [app] ERROR: Scanner error - while scanning for the next token at line 11, column 17 found character that cannot start any token at line 11, column 17 (../lib/app/ogs-init.c:214)
default: 05/20 13:17:14.889: [app] FATAL: Open5GS initialization failed. Aborted (../src/main.c:215)
default: Open5GS daemon v2.7.7-45-g30eac69
```

**Explanation:** When you run `ninja install`, Meson reads the raw template files from the git repository (which contain `@sysconfdir@`) and automatically replaces `@sysconfdir@` with your actual installation path (`/home/vagrant/open5gs/install/etc/open5gs`). It puts these correctly generated files into the `install/etc/open5gs/` directory. However, immediately after that, your script **overwrites** those perfectly generated files with the raw files from `/vagrant/configs/open5gs/`

**Fix:**
- Use `sed` to apply your custom settings instead of overwriting
