#!/bin/bash -xe

# set apt to non-iteractive mode
export DEBIAN_FRONTEND=noninteractive

# configure APT and MSFT repos
echo 'deb [arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu bionic main' | sudo tee /etc/apt/sources.list.d/intel-sgx.list
wget -qO - https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | sudo apt-key add -
echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-7 main" | sudo tee /etc/apt/sources.list.d/llvm-toolchain-bionic-7.list
wget -qO - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
echo "deb [arch=amd64] https://packages.microsoft.com/ubuntu/18.04/prod bionic main" | sudo tee /etc/apt/sources.list.d/msprod.list
wget -qO - https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

# install SGX DCAP Driver
sudo apt -y update
sudo apt -y install dkms

# TODO: bumping the driver version currently causes problems, 1.4 is not the latest
wget https://download.01.org/intel-sgx/sgx-dcap/1.4/linux/distro/ubuntuServer18.04/sgx_linux_x64_driver_1.21.bin -O sgx_linux_x64_driver.bin
chmod +x sgx_linux_x64_driver.bin
sudo ./sgx_linux_x64_driver.bin

# install tools and dependencies
sudo apt -y install clang-7 libssl-dev gdb libsgx-enclave-common \
libsgx-enclave-common-dev libprotobuf10 libsgx-dcap-ql libsgx-dcap-ql-dev \
az-dcap-client open-enclave protobuf-compiler

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
export PATH=$HOME/.cargo/bin:$PATH

# switch to rust nightly
rustup default nightly

# install Fortanix Rust EDP utils
cargo +nightly install fortanix-sgx-tools sgxs-tools

# add Fortanix build target
rustup target add x86_64-fortanix-unknown-sgx

# run utility to check SGX is configured properly
sgx-detect

