*   Import the public key used by the package management system.
*   `sudo apt update`
*   `sudo apt install gnupg`
*   `curl -fsSL https://pgp.mongodb.com/server-8.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor`

*   Create the list file /etc/apt/sources.list.d/mongodb-org-8.0.list
*     echo "deb \[ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg\] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list


*   Install the MongoDB
*   `sudo apt update`
*   `sudo apt install -y mongodb-org`
*   `sudo systemctl start mongod` ( if '/usr/bin/mongod' is not running)
*   `sudo systemctl enable mongod` ( ensure to automatically start it on system boot)

*   Setup TUN [TIP:configure the TUN device](https://github.com/open5gs/open5gs/blob/main/misc/netconf.sh)
*     sudo ip tuntap add name ogstun mode tun 2>/dev/null || true
      sudo ip addr add 10.45.0.1/16 dev ogstun 2>/dev/null || true
      sudo ip addr add 2001:db8:cafe::1/48 dev ogstun 2>/dev/null || true
      sudo ip link set ogstun up
      sudo sysctl -w net.ipv4.ip\_forward=1
      sudo sysctl -w net.ipv6.conf.all.forwarding=1
      sudo iptables -t nat -A POSTROUTING -s 10.45.0.0/16 ! -o ogstun -j MASQUERADE 2>/dev/null || true
      sudo ip6tables -t nat -A POSTROUTING -s 2001:db8:cafe::/48 ! -o ogstun -j MASQUERADE 2>/dev/null || true



*   Install the common dependencies
*     sudo apt install -y \\
          python3-pip \\
          python3-setuptools \\
          python3-wheel \\
          ninja-build \\
          build-essential \\
          flex \\
          bison \\
          git \\
          cmake \\
          libsctp-dev \\
          libgnutls28-dev \\
          libgcrypt20-dev \\
          libssl-dev \\
          libmongoc-dev \\
          libbson-dev \\
          libyaml-dev \\
          libnghttp2-dev \\
          libmicrohttpd-dev \\
          libcurl4-gnutls-dev \\
          libtins-dev \\
          libtalloc-dev \\
          meson

*   Install libidn-dev or libidn11-dev depending on your system
*     if apt-cache show libidn-dev > /dev/null 2>&1; then
          sudo apt-get install -y --no-install-recommends libidn-dev
      else
          sudo apt-get install -y --no-install-recommends libidn11-dev
      fi

*   Git clone
*     git clone --recursive https://github.com/open5gs/open5gs

*   Build
*     meson build --prefix=\`pwd\`/install
      ninja -C build
      cd build
      ninja install
      cd ../


*   Copy Config from host to vm
*     mkdir -p /home/vagrant/open5gs/install/etc/open5gs/
      cp /vagrant/configs/open5gs/\*.yaml /home/vagrant/open5gs/install/etc/open5gs/

*   Run open5gs with configs
*     sudo /home/vagrant/open5gs/install/bin/open5gs-nrfd -D -c /home/vagrant/open5gs/install/etc/open5gs/nrf.yaml
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

*   Install Webui and Run.
*     cd /home/vagrant/open5gs/webui
      sudo npm ci
      HOSTNAME=0.0.0.0 npm run dev & disownd