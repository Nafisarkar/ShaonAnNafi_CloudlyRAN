#!/bin/bash

# --- Clone and Compile Open5GS Source ---
cd /home/vagrant

if [ -d "/home/vagrant/open5gs" ]; then
	echo "Open5GS already built. Skipping build."
	cd /home/vagrant/open5gs
else
	git clone --recursive https://github.com/open5gs/open5gs
	cd /home/vagrant/open5gs
	# Build & Install locally
	meson build --prefix=`pwd`/install
	ninja -C build
	cd build
	ninja install
	cd ../
fi
# --- Pipe the hash on the home dir ---
git log -1 > /home/vagrant/open5gs_hash.log

# --- Show installed binaries ---
echo "Installed binaries:"
ls -l install/bin/open5gs-*

# --- Kill Open5gs Processes if running ---
sudo pkill -f open5gs- || true
sleep 1


# --- Install webgui and Run ---
echo "Installing WebUI of Open5GS"
cd /home/vagrant/open5gs/webui

sudo npm i
nohup sudo HOSTNAME=0.0.0.0 npm run dev &
