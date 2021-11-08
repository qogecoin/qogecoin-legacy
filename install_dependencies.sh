#!/bin/bash
# Copyright 2021 The Qogecoin Authors. All Rights Reserved.

install_dependencies() {
  sudo apt install -y \
       autoconf \
       automake \
       autotools-dev \
       bsdmainutils \
       build-essential \
       git \
       libboost-all-dev \
       libssl-dev \
       libevent-dev \
       libtool \
       pkg-config \
       python3

# Build berkeley-db-4.8.3 from source.
  wget http://download.oracle.com/berkeley-db/db-4.8.30.zip
  checksum="4f538b56681a871cc71658ed9a6120081b74b474eaa73ba2c958abea04cc98ce"
    if ! echo "$checksum db-4.8.30.zip" | sha256sum -c -; then
      echo "Checksum failed" >&2
    exit 1
  fi
  unzip db-4.8.30.zip && cd db-4.8.30
  sudo sed -i 's/__atomic_compare_exchange/__atomic_compare_exchange_db/g' dbinc/atomic.h
  cd build_unix/
  ../dist/configure --prefix=/usr/local --enable-cxx
  make -j$(nproc)
  sudo make install
  export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/lib"
  
# Gui dependencies.
  sudo apt install -y \
       libprotobuf-dev \
       libqt5core5a \
       libqt5dbus5 \
       libqt5gui5 \
       libqrencode-dev \
       protobuf-compiler \
       qttools5-dev \
       qttools5-dev-tools
}

install_dependencies
