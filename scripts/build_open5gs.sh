#!/bin/bash

# --- Clone and Compile Open5GS Source ---

git clone --recursive https://github.com/open5gs/open5gs
cd open5gs

git log -1 > ../open5gs_hash.log

meson build --prefix=`pwd`/install
ninja -C build
cd build
ninja install
cd ../


# --- Show installed binaries ---
echo "Installed binaries:"
ls -l install/bin/open5gs-*

echo "Starting All 5G Core Network Functions..."

cd /home/vagrant/open5gs
# USE LOOP
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
sudo ./install/bin/open5gs-hssd -D -c ./install/etc/open5gs/hss.yaml
sudo ./install/bin/open5gs-pcrfd -D -c ./install/etc/open5gs/pcrf.yaml
cd ~

# --- Install webgui and Run ---
echo "Installing WebUI of Open5GS"
cd /home/vagrant/open5gs/webui
sudo npm ci
nohup sudo HOSTNAME=0.0.0.0 PORT=9999 npm run dev > /home/vagrant/webui.log 2>&1 &

cd ~
