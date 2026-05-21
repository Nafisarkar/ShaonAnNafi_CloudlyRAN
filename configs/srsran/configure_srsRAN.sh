#! /bin/bash

CONF_DEST="/usr/local/etc/srsran"

echo "Applying srsRAN custom configurations"

sudo mkdir -p $CONF_DEST

# -- Copy custom config to   --
sudo cp /vagrant/configs/srsran/gnb_zmq.yaml $CONF_DEST/gnb.yml

# -- AMF Configuration in gbn --
sudo sed -i 's/addr: 10.53.1.2/addr: 10.10.0.2/g' $CONF_DEST/gnb.yml

# -- Bind Vm ip in gbn --
sudo sed -i 's/bind_addr: 10.53.1.1/bind_addr: 10.10.0.2/g' $CONF_DEST/gnb.yml

# -- Tac in gbn --
sudo sed -i 's/tac: 7/tac: 1/g' $CONF_DEST/gnb.yml

echo "srsRAN good to go"