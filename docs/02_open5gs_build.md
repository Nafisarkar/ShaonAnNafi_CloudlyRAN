## MongoDB Setup

### Import Public Key

- Import the public key used by the package management system
- `sudo apt update`
- `sudo apt install gnupg`
- `curl -fsSL https://pgp.mongodb.com/server-8.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor`

### Create MongoDB Repository

- Create the list file /etc/apt/sources.list.d/mongodb-org-8.0.list

```bash
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
```

### Install MongoDB

- `sudo apt update`
- `sudo apt install -y mongodb-org`
- `sudo systemctl start mongod` (if '/usr/bin/mongod' is not running)
- `sudo systemctl enable mongod` (ensure to automatically start it on system boot)

## Network Setup

### Configure TUN Device

See [TUN device configuration](https://github.com/open5gs/open5gs/blob/main/misc/netconf.sh)

```bash
sudo ip tuntap add name ogstun mode tun 2>/dev/null || true
sudo ip addr add 10.45.0.1/16 dev ogstun 2>/dev/null || true
sudo ip addr add 2001:db8:cafe::1/48 dev ogstun 2>/dev/null || true
sudo ip link set ogstun up
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv6.conf.all.forwarding=1
sudo iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE 2>/dev/null || true
sudo ip6tables -t nat -A POSTROUTING -s 2001:db8:cafe::/48 ! -o ogstun -j MASQUERADE 2>/dev/null || true
```
## Installation and Build

### Install Common Dependencies

```bash
sudo apt install -y \
      python3-pip \
      python3-setuptools \
      python3-wheel \
      ninja-build \
      build-essential \
      flex \
      bison \
      git \
      cmake \
      libsctp-dev \
      libgnutls28-dev \
      libgcrypt20-dev \
      libssl-dev \
      libmongoc-dev \
      libbson-dev \
      libyaml-dev \
      libnghttp2-dev \
      libmicrohttpd-dev \
      libcurl4-gnutls-dev \
      libtins-dev \
      libtalloc-dev \
    meson
```

### Install libidn-dev or libidn11-dev

Depending on your system:

```bash
if apt-cache show libidn-dev > /dev/null 2>&1; then
    sudo apt-get install -y --no-install-recommends libidn-dev
else
    sudo apt-get install -y --no-install-recommends libidn11-dev
fi
```
### Clone Repository

```bash
git clone --recursive https://github.com/open5gs/open5gs
```
### Build

```bash
meson build --prefix=`pwd`/install
ninja -C build
cd build
ninja install
cd ../
```
### Run Open5GS with Configs

```
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
  ```
- Install Webui and Run in Background.
-
  ```echo
  cd /home/vagrant/open5gs/webui
  sudo npm ci
  sudo -u vagrant nohup sh -c "HOST=0.0.0.0 PORT=9999 npm run dev" > /home/vagrant/webui.log 2>&1 &
  ```
- Added configuration script - Will run after installing and invoking
	- NRF
		-
		  sudo sed -i 's/mcc: 999/mcc: 001/g' "$CONF_DIR/nrf.yaml"
		  sudo sed -i 's/mnc: 70/mnc: 01/g' "$CONF_DIR/nrf.yaml"

	- AMF
		-
		  sudo sed -i 's/mcc: 999/mcc: 001/g' "$CONF_DIR/amf.yaml"
		  sudo sed -i 's/mnc: 70/mnc: 01/g' "$CONF_DIR/amf.yaml"
		  sudo sed -i '/ngap:/,/metrics:/s/127.0.0.5/10.10.0.5/' "$CONF_DIR/amf.yaml"

	- UPF
		-
		  sudo sed -i 's/address: 127.0.0.7/address: 10.11.0.7/g' "$CONF_DIR/upf.yaml"
	- MME
		-
		  sudo sed -i 's/mcc: 999/mcc: 001/g' "$CONF_DIR/mme.yaml"
		  sudo sed -i 's/mnc: 70/mnc: 01/g' "$CONF_DIR/mme.yaml"
		  sudo sed -i '/s1ap:/,/gtpc:/s/127.0.0.2/10.10.0.2/' "$CONF_DIR/mme.yaml"
	- SGWU
		-
		  sudo sed -i 's/address: 127.0.0.6/address: 10.11.0.6/g' "$CONF_DIR/sgwu.yaml"
