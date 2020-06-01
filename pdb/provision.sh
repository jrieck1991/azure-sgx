#!/bin/bash -xe

# build binary
cd pdb
cargo build

# cp binary
cp target/x86_64-fortanix-unknown-sgx/debug/pdb pdb

# convert from ELF to sized SGXS format
# TODO: tune these params
ftxsgx-elf2sgxs pdb --heap-size 0x20000 --stack-size 0x20000 --threads 10 --debug

# generate signing key
openssl genrsa -3 3072 > pdb.pem

# sign sgxs file
# generates pdb.sig, keep this in same dir as sgxs binary
# TODO: tune these params
sgxs-sign --key pdb.pem pdb.sgxs pdb.sig -d --xfrm 7/0 --isvprodid 0 --isvsvn 0
