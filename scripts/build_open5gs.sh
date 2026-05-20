#!/bin/bash

# --- Clone and Compile Open5GS Source ---

git clone --recursive https://github.com/open5gs/open5gs
cd open5gs

meson build --prefix=`pwd`/install
ninja -C build
cd build
ninja install
cd ../

# --- Show installed binaries ---
echo "Installed binaries:"
ls -l install/bin/open5gs-*

echo "Starting All 5G Core Network Functions..."
echo "Syncing custom host configurations..."
mkdir -p /home/vagrant/open5gs/install/etc/open5gs/
cp /vagrant/configs/open5gs/*.yaml /home/vagrant/open5gs/install/etc/open5gs/

cd /home/vagrant/open5gs
# USE LOOP
sudo /home/vagrant/open5gs/install/bin/open5gs-nrfd -D -c /home/vagrant/open5gs/install/etc/open5gs/nrf.yaml
sudo /home/vagrant/open5gs/install/bin/open5gs-scpd -D -c /home/vagrant/open5gs/install/etc/open5gs/scp.yaml
sudo /home/vagrant/open5gs/install/bin/open5gs-seppd -D -c /home/vagrant/open5gs/install/etc/open5gs/sepp1.yaml
sudo /home/vagrant/open5gs/install/bin/open5gs-amfd -D -c /home/vagrant/open5gs/install/etc/open5gs/amf.yaml
sudo /home/vagrant/open5gs/install/bin/open5gs-smfd -D -c /home/vagrant/open5gs/install/etc/open5gs/smf.yaml
sudo /home/vagrant/open5gs/install/bin/open5gs-upfd -D -c /home/vagrant/open5gs/install/etc/open5gs/upf.yaml
sudo /home/vagrant/open5gs/install/bin/open5gs-ausfd -D -c /home/vagrant/open5gs/install/etc/open5gs/ausf.yaml
sudo /home/vagrant/open5gs/install/bin/open5gs-udmd -D -c /home/vagrant/open5gs/install/etc/open5gs/udm.yaml
sudo /home/vagrant/open5gs/install/bin/open5gs-pcfd -D -c /home/vagrant/open5gs/install/etc/open5gs/pcf.yaml
sudo /home/vagrant/open5gs/install/bin/open5gs-nssfd -D -c /home/vagrant/open5gs/install/etc/open5gs/nssf.yaml
sudo /home/vagrant/open5gs/install/bin/open5gs-bsfd -D -c /home/vagrant/open5gs/install/etc/open5gs/bsf.yaml
sudo /home/vagrant/open5gs/install/bin/open5gs-udrd -D -c /home/vagrant/open5gs/install/etc/open5gs/udr.yaml
sudo /home/vagrant/open5gs/install/bin/open5gs-mmed -D -c /home/vagrant/open5gs/install/etc/open5gs/mme.yaml
sudo /home/vagrant/open5gs/install/bin/open5gs-sgwcd -D -c /home/vagrant/open5gs/install/etc/open5gs/sgwc.yaml
sudo /home/vagrant/open5gs/install/bin/open5gs-sgwud -D -c /home/vagrant/open5gs/install/etc/open5gs/sgwu.yaml
sudo /home/vagrant/open5gs/install/bin/open5gs-hssd -D -c /home/vagrant/open5gs/install/etc/open5gs/hss.yaml
sudo /home/vagrant/open5gs/install/bin/open5gs-pcrfd -D -c /home/vagrant/open5gs/install/etc/open5gs/pcrf.yaml
cd ~

echo "Installing WebUI of Open5GS"
cd /home/vagrant/open5gs/webui
sudo npm ci
nohup sudo HOSTNAME=0.0.0.0 PORT=9999 npm run dev > /home/vagrant/webui.log 2>&1 &
