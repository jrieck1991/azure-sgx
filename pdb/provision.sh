#!/bin/bash -xe

# workdir
cd pdb

# install rocksdb
sudo apt -y update
sudo apt -y install clang librocksdb-dev

# build binaries
rustup target add x86_64-fortanix-unknown-sgx && \
make trusted && make dal

# cp to working dir
cp target/x86_64-fortanix-unknown-sgx/debug/trusted ../trusted
cp target/x86_64-unknown-linux-gnu/debug/dal ../dal
cd ..

# convert from ELF to sized SGXS format
# TODO: tune these params
ftxsgx-elf2sgxs trusted --heap-size 0x20000 --stack-size 0x20000 --threads 10 --debug

# generate signing key
openssl genrsa -3 3072 > trusted.pem

# sign sgxs file
# generates pdb.sig, keep this in same dir as sgxs binary
# TODO: tune these params
sgxs-sign --key trusted.pem trusted.sgxs trusted.sig -d --xfrm 7/0 --isvprodid 0 --isvsvn 0

# to run 'ftxsgx-runner trusted.sgxs'
