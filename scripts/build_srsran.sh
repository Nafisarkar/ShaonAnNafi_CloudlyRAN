#!/bin/bash


cd /home/vagrant
# --- Install Dependency ---
sudo apt install -y \
    cmake \
    make \
    gcc \
    g++ \
    pkg-config \
    libfftw3-dev \
    libmbedtls-dev \
    libsctp-dev \
    libyaml-cpp-dev \
    libgtest-dev \
    libboost-program-options-dev \
    libboost-serialization-dev \
    libzmq3-dev \
    git \
    ca-certificates




if [ -d "/home/vagrant/srsRAN_Project" ]; then
    echo "srsRAN already built. Skipping build."
    cd /home/vagrant/srsRAN_Project
else
    # --- Clone and Compile ---
    git clone --recursive https://github.com/srsRAN/srsRAN_Project.git
    cd srsRAN_Project
    git log -1 > ../srsran_hash.log
    mkdir build
    cd build
    cmake ../ -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_CXX_FLAGS="-Os" \
          -DENABLE_EXPORT=ON \
          -DENABLE_ZEROMQ=ON
    make -j $(nproc)
    # --- Install ---
    sudo make install
fi