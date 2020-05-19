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
pushd oasis-core && \
rustup target add x86_64-fortanix-unknown-sgx && \
OASIS_UNSAFE_SKIP_AVR_VERIFY=1 OASIS_UNSAFE_KM_POLICY_KEYS=1 OASIS_UNSAFE_ALLOW_DEBUG_ENCLAVES=1 make
popd

# copy oasis-node binary to path
sudo cp oasis-core/go/oasis-node/oasis-node /usr/bin
