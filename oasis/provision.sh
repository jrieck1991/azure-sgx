#!/bin/bash -xe

# run utility to check SGX is configured properly before starting
sgx-detect

# add golang repo for latest go version
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt -y update

# install tools
sudo apt -y install bubblewrap cmake libseccomp-dev golang-go

# clone latest release of oasis-core
git clone --depth 1 -b v20.6 https://github.com/oasislabs/oasis-core.git

# build oasis
# TODO: use TEE
pushd oasis-core && \
rustup target add x86_64-fortanix-unknown-sgx && \
OASIS_UNSAFE_SKIP_AVR_VERIFY=1 OASIS_UNSAFE_SKIP_KM_POLICY=1 make
popd
