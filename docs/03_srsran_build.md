## Dependencies Installation

```bash
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
```

## Clone srsRAN Project

```bash
git clone --recursive https://github.com/srsRAN/srsRAN_Project.git
```

## Build and Compile (with ZeroMQ enabled)

```bash
mkdir build
cd build
cmake ../ -DENABLE_EXPORT=ON -DENABLE_ZEROMQ=ON
make -j $(nproc)
make test -j $(nproc)
```

## Install the Binaries

```bash
sudo make install
```
