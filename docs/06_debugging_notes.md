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

## Issue 4: Mongodb Crash Randomly
```
× mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
     Active: failed (Result: exit-code) since Thu 2026-05-21 09:35:49 UTC; 11s ago
       Docs: https://docs.mongodb.org/manual
    Process: 35883 ExecStart=/usr/bin/mongod --config /etc/mongod.conf (code=exited, status=1/FAILURE)
   Main PID: 35883 (code=exited, status=1/FAILURE)
        CPU: 84ms

May 21 09:35:49 vagrant mongod[35883]:   Frame: {"a":"55DA47AB5E21","b":"55DA4260C000","o":"54A9E21","s":"_ZN5mongo30initialize_server_global_state46_mongoInitializerFunction_Server>
May 21 09:35:49 vagrant mongod[35883]:   Frame: {"a":"55DA4B695730","b":"55DA4260C000","o":"9089730","s":"_ZN5mongo11Initializer19executeInitializersERKSt6vectorINSt7__cxx1112basic_>
May 21 09:35:49 vagrant mongod[35883]:   Frame: {"a":"55DA4B695C7E","b":"55DA4260C000","o":"9089C7E","s":"_ZN5mongo21runGlobalInitializersERKSt6vectorINSt7__cxx1112basic_stringIcSt1>
May 21 09:35:49 vagrant mongod[35883]:   Frame: {"a":"55DA46D9289A","b":"55DA4260C000","o":"478689A","s":"_ZN5mongo11mongod_mainEiPPc","C":"mongo::mongod_main(int, char**)","s+":"9A>
May 21 09:35:49 vagrant mongod[35883]:   Frame: {"a":"55DA46D76649","b":"55DA4260C000","o":"476A649","s":"main","s+":"9"}
May 21 09:35:49 vagrant mongod[35883]:   Frame: {"a":"7F40D63D0D90","b":"7F40D63A7000","o":"29D90"}
May 21 09:35:49 vagrant mongod[35883]:   Frame: {"a":"7F40D63D0E40","b":"7F40D63A7000","o":"29E40","s":"__libc_start_main","s+":"80"}
May 21 09:35:49 vagrant mongod[35883]:   Frame: {"a":"55DA46D76525","b":"55DA4260C000","o":"476A525","s":"_start","s+":"25"}
May 21 09:35:49 vagrant systemd[1]: mongod.service: Main process exited, code=exited, status=1/FAILURE
May 21 09:35:49 vagrant systemd[1]: mongod.service: Failed with result 'exit-code'.
```
**Explanation:** Aperanty the when running all the open5gs services the open5gs-hssd and open5gs-pcrfd are creating log file that are huge and consuming all the available spaces, causing mongodb to crash.

**Fix:**
- Remove hssd -  replaced by UDM/UDR in 5G
- Remove pcrfd - replaced by PCF in 5G

## Issue 5: Host Machine Port 9999 Already in Use

**Error:** WebUI not accessible at `http://localhost:9999` from the host browser even though the VM forwarded port is configured.

**Explanation:** The host machine already had another application listening on port `9999`, so the Vagrant forwarded port mapping (`guest: 9999, host: 9999`) failed silently or mapped to a random port.

**Fix:**
- Forwarded a different host port instead:
  ```ruby
  config.vm.network "forwarded_port", guest: 9999, host: 8080
  ```
- Access the WebUI at `http://localhost:8080` from the host machine instead.



## Issue 5: Node module folder cant be created.

```
   default: Installing WebUI of Open5GS
    default: npm warn EBADENGINE Unsupported engine {
    default: npm warn EBADENGINE   package: 'react-jsonschema-form@0.50.1',
    default: npm warn EBADENGINE   required: { node: '>=6', npm: '^2.14.7' },
    default: npm warn EBADENGINE   current: { node: 'v20.20.2', npm: '10.8.2' }
    default: npm warn EBADENGINE }
    default: npm error code EACCES
    default: npm error syscall mkdir
    default: npm error path /home/vagrant/open5gs/webui/node_modules
    default: npm error errno -13
    default: npm error Error: EACCES: permission denied, mkdir '/home/vagrant/open5gs/webui/node_modules'
    default: npm error     at async mkdir (node:internal/fs/promises:856:10)
    default: npm error     at async /usr/lib/node_modules/npm/node_modules/@npmcli/arborist/lib/arborist/reify.js:624:20
    default: npm error     at async Promise.allSettled (index 0)
    default: npm error     at async [reifyPackages] (/usr/lib/node_modules/npm/node_modules/@npmcli/arborist/lib/arborist/reify.js:325:11)
    default: npm error     at async Arborist.reify (/usr/lib/node_modules/npm/node_modules/@npmcli/arborist/lib/arborist/reify.js:142:5)
    default: npm error     at async CI.exec (/usr/lib/node_modules/npm/lib/commands/ci.js:100:5)
    default: npm error     at async Npm.exec (/usr/lib/node_modules/npm/lib/npm.js:207:9)
    default: npm error     at async module.exports (/usr/lib/node_modules/npm/lib/cli/entry.js:74:5) {
    default: npm error   errno: -13,
    default: npm error   code: 'EACCES',
    default: npm error   syscall: 'mkdir',
    default: npm error   path: '/home/vagrant/open5gs/webui/node_modules'
    default: npm error }
    default: npm error
    default: npm error The operation was rejected by your operating system.
    default: npm error It is likely you do not have the permissions to access this file as the current user
    default: npm error
    default: npm error If you believe this might be a permissions issue, please double-check the
    default: npm error permissions of the file and its containing directories, or try running
    default: npm error the command again as root/Administrator.
    default: npm error A complete log of this run can be found in: /home/vagrant/.npm/_logs/2026-05-21T14_24_15_071Z-debug-0.log
==> default: Running provisioner: shell...
    default: Running: C:/Users/Nafi/AppData/Local/Temp/vagrant-shell20260521-12944-ujp1gk.sh
```

**Explanation** Vagrant executes provisioning scripts as the root user by default. When your script ran git clone .inside the else block, that fresh open5gs folder was created by root. Therefore, the webui folder was owned entirely by root.

**Fix:**
  - to fix this open5gs folder should be owned by the vagrant user before running npm