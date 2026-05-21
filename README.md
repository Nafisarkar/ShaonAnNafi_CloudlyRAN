## Final Status
- Vagrant VM: Working
- Open5GS Build: Working
- srsRAN Build: Working
- Open5GS + srsRAN Integration: Working

## Key Learnings

- **Radio & Core Integration:** Learned how cell components connect by tying radio parameters (gNB) directly to network functions.
- **Infrastructure Automation:** Realized how powerful properly orchestrated virtualization tools are for deploying complex software. Automating the lifecycle in a strict sequence—dependencies, source compilation, configuration overrides, and service flushes—makes an otherwise painful environment reproducible and stable.
- **Logging & Documentation:** Realized that system logs are the ultimate source of truth for troubleshooting silent permission blocks, while clear documentation is mandatory to align identical configuration keys across different software suites.
- **Strict Version Control:** Understood the necessity of pinning exact software environments using unique commit hashes to guarantee automated pipelines remain reproducible.

## Known Issues

MongoDB Core Dump Error
---

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

---
Open5GS WebUI — Start / Restart Manually
---

The WebUI runs on port **9999**. Check if it's up:

```bash
sudo ss -lnput | grep 9999
```

- **If you see a `node` process listening** — the WebUI is running.
- **If nothing shows** — start it manually:

```bash
cd /home/vagrant/open5gs/webui

# Optional: reinstall dependencies if they're corrupted
sudo npm install

# Start in background
nohup sudo HOSTNAME=0.0.0.0 PORT=9999 npm run dev &
```

**Verify it started:**
```bash
sleep 2
sudo ss -lnput | grep 9999
```

**Check the log if it fails to start:**
```bash
cat /home/vagrant/nohup.out
```

> **Note:** If you see `npm audit` warnings or `EBADENGINE` warnings about `react-jsonschema-form`, they can be safely ignored — the WebUI works despite these warnings.

### If the WebUI keeps failing (common fixes)

| Symptom                     | Fix                                                    |
|-----------------------------|--------------------------------------------------------|
| Port 9999 already in use    | `sudo kill $(sudo lsof -t -i:9999)` then retry         |
| `node_modules` corrupted    | `rm -rf node_modules package-lock.json && sudo npm install` |
| npm not found               | `sudo apt install -y nodejs npm`                       |
| WebUI returns blank page    | Check browser console; try forwarding port 9999 again  |

---

Disk Space — Log File Pruning
---
### Open5GS logs can grow large over time and fill up the VM disk.

### Check disk usage
```bash
df -h
```

### Check log sizes
```bash
du -sh /home/vagrant/open5gs/install/var/log/open5gs/
ls -lh /home/vagrant/open5gs/install/var/log/open5gs/
```

### Rotate or clear logs
```bash
# Truncate all Open5GS logs (safe — services keep running)
sudo truncate -s 0 /home/vagrant/open5gs/install/var/log/open5gs/*.log

# Or remove and let them be recreated
sudo rm -f /home/vagrant/open5gs/install/var/log/open5gs/*.log
```



### Also clean npm caches and apt caches
```bash
# Free up additional space
sudo apt clean
sudo npm cache clean --force
```


## References Used
## Vagrant

### Basic Tutorials
- https://www.youtube.com/watch?v=czMCO1w-xQU
- https://www.youtube.com/watch?v=7DLfOGt8YvA&t=1764s
- https://www.youtube.com/watch?v=349ul4Wuj9I
- https://www.youtube.com/watch?v=bIJCN57N0Kc
- https://www.youtube.com/watch?v=Q6qL2tU1d-8
- https://www.youtube.com/watch?v=qKyqv4G64Yc
- https://www.youtube.com/watch?v=Dovd-CcyR7A
- https://www.youtube.com/watch?v=PF4NSHzW75g
- https://www.youtube.com/watch?v=aqqyJxvzsag

### Documentation
- https://nuradioconcepts.io/2023/12/13/building-a-personal-open-source-5g-network/
- https://developer.hashicorp.com/vagrant/docs/networking/basic_usage
- https://developer.hashicorp.com/vagrant/docs/networking/forwarded_ports

### Shell Provisioning
- https://developer.hashicorp.com/vagrant/docs/provisioning/shell

### Images
- [ubuntu22.04](https://portal.cloud.hashicorp.com/vagrant/discover/bento/ubuntu-22.04)

## Open5GS

### Documentation
- https://open5gs.org/open5gs/docs/guide/01-quickstart/
- https://open5gs.org/open5gs/docs/guide/02-building-open5gs-from-sources/
- https://kkohls.info/guides_open5gs
- https://hackmd.io/@cho5gsec/Skr2kOkeee

### Build From Source
- https://open5gs.org/open5gs/docs/guide/02-building-open5gs-from-sources/

## MongoDB

### Documentation
- https://www.mongodb.com/community/forums/t/setting-up-mongodb-v5-0-on-ubuntu-20-core-dump-status-4-ill/120705

## SRSRAN

### Documentation
- https://docs.srsran.com/projects/project/en/latest/user_manuals/source/installation.html
- https://hackmd.io/@leo661314/Hkj1B8OD0
- https://github.com/srsran/oran-sc-ric/blob/main/e2-agents/srsRAN/gnb_zmq.yaml
- https://github.com/s5uishida/build_srsran_5g_zmq

### Integration
- https://www.youtube.com/watch?v=dn2V1daWnXY
- https://www.youtube.com/watch?v=DSxbhpWRvaI

**AI & Assistants**
  - Deepseek V4 Flash (Architectural troubleshooting, research and debugging)
  - Qwen 3.6 Plus (Technical documentation engineering and Markdown formatting)