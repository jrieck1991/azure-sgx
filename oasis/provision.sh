#!/bin/bash -xe

# run utility to check SGX is configured properly before starting
sgx-detect

# install tools
sudo apt -y update
sudo apt -y install -y git bubblewrap gcc gcc-c++ \
make cmake openssl-devel libseccomp-devel

# install golang
wget https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz -O go.tar.gz
tar -C /usr/local -xzf go.tar.gz
export PATH=/usr/local/go/bin:$PATH

# clone latest release of oasis-core
git clone --depth 1 -b v20.6 https://github.com/oasislabs/oasis-core.git

# build oasis
pushd oasis-core && \
rustup target add x86_64-fortanix-unknown-sgx && \
OASIS_UNSAFE_SKIP_AVR_VERIFY=1 OASIS_UNSAFE_SKIP_KM_POLICY=1 make
popd
