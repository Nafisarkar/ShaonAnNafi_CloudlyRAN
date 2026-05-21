
## Open5gs Configuration
**NRF, AMF, and MME Configuration:**
   - Changed Mobile Country Code (MCC) from `999` to `001`.
   - Changed Mobile Network Code (MNC) from `70` to `01`.
   - Applied to: `nrf.yaml`, `amf.yaml`, `mme.yaml`.

**AMF Binding:**
   - Changed interface IP address from `127.0.0.5` to `10.10.0.2` in `amf.yaml`.

**MME Binding:**
   - Changed interface IP address from `127.0.0.2` to `10.10.0.2` in `mme.yaml`.

**UPF Configuration:**
   - Changed address from `127.0.0.7` to `10.11.0.2` in `upf.yaml`.

**SGWU Configuration:**
   - Changed address from `127.0.0.6` to `10.11.0.2` in `sgwu.yaml`.

**Service Restart:**
   - After applying the changes, the script restarts all Open5GS services

## srsRAN Configuration

**Custom Configuration :**
   - Copies the custom gNB configuration file `gnb_zmq.yaml` from `/vagrant/configs/srsran/` to `/usr/local/etc/srsran/gnb.yml`.

**gNB Configuration Updates:**
   - Changed the AMF address (`addr`) from `10.53.1.2` to `10.10.0.2` in `gnb.yml`.
   - Changed the gNB bind address (`bind_addr`) from `10.53.1.1` to `10.10.0.2` in `gnb.yml`.
   - Changed the Tracking Area Code (`tac`) from `7` to `1` in `gnb.yml`.

## How the Integration Works
The integration ensures that the Open5GS core network and the srsRAN gNB are configured to communicate over the same network interfaces:

- The Open5GS AMF is configured to listen for NGAP connections on `10.10.0.2` (from `amf.yaml`).
- The Open5GS MME is configured to listen for S1AP connections on `10.10.0.2` (from `mme.yaml`).
- The srsRAN gNB is configured to connect to the AMF at `10.10.0.2` and to bind its own NGAP interface to `10.10.0.2` (from `gnb.yml`).
- The Open5GS UPF and SGWU are configured to use the IP address `10.11.0.2` for user plane traffic.

## Notes
- The IP addresses `10.10.0.2` and `10.11.0.2` are assumed to be the VM's internal network interfaces for control and user plane, respectively.
- VM has the IP addresses `10.10.0.2` and `10.11.0.2` configured on its network interfaces.

