#!/bin/bash

echo "Updating package lists..."
sudo apt update
sudo apt upgrade -y


sudo add-apt-repository ppa:zhangsongcui3371/fastfetch

echo "System update and upgrade complete!"


sudo apt install fastfetch git

fastfetch