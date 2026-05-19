- *Issue.1*
-
  ```
  - VBoxManage.exe: error: Details: code E_ACCESSDENIED (0x80070005), component MachineWrap, interface IMachine, callee IUnknown
  - VBoxManage.exe: error: Context: "LockMachine(a->session, LockType_Shared)" at line 3328 of file VBoxManageInfo.cpp
  ```
- *Explanation*: often caused by trying to access a Virtual Machine (VM) that is already locked by another process or an orphaned session
- *Fix*:
	- Remove Inaccessible VMs
	- restart virtual box
	- restart host
