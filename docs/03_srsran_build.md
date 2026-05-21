## Dependencies

```bash
sudo apt install -y \
    cmake make gcc g++ pkg-config \
    libfftw3-dev libmbedtls-dev libsctp-dev libyaml-cpp-dev \
    libgtest-dev libboost-program-options-dev libboost-serialization-dev \
    libzmq3-dev git ca-certificates
```

## Clone & Build
- `DCMAKE_BUILD_TYPE=Release` for a production-ready build.
- `DCMAKE_CXX_FLAGS="-Os"` It applies all the standard -O2 optimizations.
- `ENABLE_ZEROMQ=ON` enables ZeroMQ for ZMQ-based I/O instead of real RF — required for virtualized setups without SDR hardware.
```bash
cd /home/vagrant
git clone --recursive https://github.com/srsRAN/srsRAN_Project.git
cd srsRAN_Project
git log -1 > ../srsran_hash.log
mkdir build && cd build

cmake ../ -DCMAKE_BUILD_TYPE=Release \
          -DCMAKE_CXX_FLAGS="-Os" \
          -DENABLE_EXPORT=ON \
          -DENABLE_ZEROMQ=ON
make -j $(nproc)
sudo make install
```

>
>
> On re-run, the script detects existing source and skips cloning/build.
