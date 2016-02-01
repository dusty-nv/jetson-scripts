#!/bin/sh
# Install arm64 gcc extensions on the NVIDIA Jetson TX1
if [ $(id -u) != 0 ]; then
   echo "This script requires root permissions"
   echo "$ sudo "$0""
   exit
fi

# Install arm64 gcc extensions
dpkg --add-architecture arm64
apt-get update
apt-get install libc6:arm64 binutils:arm64 cpp-4.8:arm64 gcc-4.8:arm64
# reassign aliases to the compiler
cd /usr/bin
rm cc gcc 
ln -s /usr/bin/aarch64-linux-gnu-gcc-4.8 cc
ln -s /usr/bin/aarch64-linux-gnu-gcc-4.8 gcc
ln -s /usr/bin/aarch64-linux-gnu-cpp-4.8 cpp
/bin/echo -e "\e[1;32mARM 64 extensions to GCC Installed.\e[0m"

