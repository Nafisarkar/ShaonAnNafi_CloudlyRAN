#!/bin/bash

# Base directory for configurations
CONF_DIR="/home/vagrant/open5gs/install/etc/open5gs"

echo "Applying configurations"

# -- NRF Configuration --
sudo sed -i 's/mcc: 999/mcc: 001/g' "$CONF_DIR/nrf.yaml"
sudo sed -i 's/mnc: 70/mnc: 01/g' "$CONF_DIR/nrf.yaml"

# -- AMF Configuration --
sudo sed -i 's/mcc: 999/mcc: 001/g' "$CONF_DIR/amf.yaml"
sudo sed -i 's/mnc: 70/mnc: 01/g' "$CONF_DIR/amf.yaml"

# Bind NGAP to the VM's actual IP
sudo sed -i '/ngap:/,/metrics:/s/127.0.0.5/10.10.0.2/' "$CONF_DIR/amf.yaml"

# -- UPF Configuration --
sudo sed -i 's/address: 127.0.0.7/address: 10.11.0.2/g' "$CONF_DIR/upf.yaml"

# -- MME Configuration --
sudo sed -i 's/mcc: 999/mcc: 001/g' "$CONF_DIR/mme.yaml"
sudo sed -i 's/mnc: 70/mnc: 01/g' "$CONF_DIR/mme.yaml"
sudo sed -i '/s1ap:/,/gtpc:/s/127.0.0.2/10.10.0.2/' "$CONF_DIR/mme.yaml"

# -- SGWU Configuration --
sudo sed -i 's/address: 127.0.0.6/address: 10.11.0.2/g' "$CONF_DIR/sgwu.yaml"

# -- AMF TAC alignment --
sudo sed -i 's/tac: 7/tac: 1/g' "$CONF_DIR/amf.yaml"
sudo sed -i 's/tac: 7/tac: 1/g' "$CONF_DIR/smf.yaml"

echo "All open5gs configurations successfully applied!"


# --- RESTART SECTION ---
echo "Restarting Open5GS services to apply new configurations..."

# --- Kill any existing instances cleanly ---
sudo pkill -f open5gs- || true
sleep 1
# --- Relaunch services in the background using the updated configs ---
cd /home/vagrant/open5gs

sudo ./install/bin/open5gs-nrfd -D -c ./install/etc/open5gs/nrf.yaml
sudo ./install/bin/open5gs-scpd -D -c ./install/etc/open5gs/scp.yaml
sudo ./install/bin/open5gs-seppd -D -c ./install/etc/open5gs/sepp1.yaml
sudo ./install/bin/open5gs-smfd -D -c ./install/etc/open5gs/smf.yaml
sudo ./install/bin/open5gs-upfd -D -c ./install/etc/open5gs/upf.yaml
sudo ./install/bin/open5gs-amfd -D -c ./install/etc/open5gs/amf.yaml
sudo ./install/bin/open5gs-ausfd -D -c ./install/etc/open5gs/ausf.yaml
sudo ./install/bin/open5gs-udmd -D -c ./install/etc/open5gs/udm.yaml
sudo ./install/bin/open5gs-pcfd -D -c ./install/etc/open5gs/pcf.yaml
sudo ./install/bin/open5gs-nssfd -D -c ./install/etc/open5gs/nssf.yaml
sudo ./install/bin/open5gs-bsfd -D -c ./install/etc/open5gs/bsf.yaml
sudo ./install/bin/open5gs-udrd -D -c ./install/etc/open5gs/udr.yaml
sudo ./install/bin/open5gs-mmed -D -c ./install/etc/open5gs/mme.yaml
sudo ./install/bin/open5gs-sgwcd -D -c ./install/etc/open5gs/sgwc.yaml
sudo ./install/bin/open5gs-sgwud -D -c ./install/etc/open5gs/sgwu.yaml

echo "Open5GS core network functions started!"
