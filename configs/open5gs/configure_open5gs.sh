#!/bin/bash

# Define the base directory for configurations
CONF_DIR="/home/vagrant/open5gs/install/etc/open5gs"

echo "Applying custom diff configurations..."

# -- NRF Configuration --
sudo sed -i 's/mcc: 999/mcc: 001/g' "$CONF_DIR/nrf.yaml"
sudo sed -i 's/mnc: 70/mnc: 01/g' "$CONF_DIR/nrf.yaml"

# -- AMF Configuration --
sudo sed -i 's/mcc: 999/mcc: 001/g' "$CONF_DIR/amf.yaml"
sudo sed -i 's/mnc: 70/mnc: 01/g' "$CONF_DIR/amf.yaml"
sudo sed -i '/ngap:/,/metrics:/s/127.0.0.5/10.10.0.5/' "$CONF_DIR/amf.yaml"

# -- UPF Configuration --
sudo sed -i 's/address: 127.0.0.7/address: 10.11.0.7/g' "$CONF_DIR/upf.yaml"

# -- MME Configuration --
sudo sed -i 's/mcc: 999/mcc: 001/g' "$CONF_DIR/mme.yaml"
sudo sed -i 's/mnc: 70/mnc: 01/g' "$CONF_DIR/mme.yaml"
sudo sed -i '/s1ap:/,/gtpc:/s/127.0.0.2/10.10.0.2/' "$CONF_DIR/mme.yaml"

# -- SGWU Configuration --
sudo sed -i 's/address: 127.0.0.6/address: 10.11.0.6/g' "$CONF_DIR/sgwu.yaml"

echo "All open5gs configurations successfully applied!"