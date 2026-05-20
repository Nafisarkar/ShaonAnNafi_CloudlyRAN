- *Issue.1*
-
  ```-
  - VBoxManage.exe: error: Details: code E_ACCESSDENIED (0x80070005), component MachineWrap, interface IMachine, callee IUnknown
  - VBoxManage.exe: error: Context: "LockMachine(a->session, LockType_Shared)" at line 3328 of file VBoxManageInfo.cpp
  ```
- *Explanation*: Caused by trying to access a Virtual Machine (VM) that is already locked by another process or an orphaned session.
- *Fix*:
	- Remove Inaccessible VMs
	- restart virtual box
	- restart host
-
- Issue.2
-
  ```×
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
- *Explanation*: VM’s CPU does not support instructions required by MongoDB 8.0, with Ryzen 3600 virtual box cant pass through AVX in virtual box provider.
- [More About This Error](https://www.mongodb.com/community/forums/t/setting-up-mongodb-v5-0-on-ubuntu-20-core-dump-status-4-ill/120705)
- if we install mongodb 4.4. We have to switch to ubuntu 20.
-
- *Fix*
	- Either use mongodb 4.4 last version that do not require AVX.
	- Use other provider as docker/vmware
		- Vmware
		- 1. install vmware
		- 2. install Vagrant VMware Utility [vmware utility](https://developer.hashicorp.com/vagrant/install/vmware)
		- 3. intsall vagrant plugin for vmware
-
-
