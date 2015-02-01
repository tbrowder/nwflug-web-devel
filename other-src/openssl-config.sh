#!/bin/bash

if [ -z "$1" ] ; then
  echo "Usage: $0 go"
  echo
  echo "  Configures openssl source (without FIPS)."
  exit
fi

# see Ivan Ristics "Bulletproof SSL and TLS," p. 316

# openssl (no FIPS) ================
# we must use the shared library for some Apache friends
# do NOT use patented algorithms without permission:

SSLDIR=/opt/openssl

./config \
    no-ec2m                         \
    no-rc5                          \
    no-idea                         \
    threads                         \
    zlib-dynamic                    \
    shared                          \
    --prefix=${SSLDIR}              \
    --openssldir=${SSLDIR}          \

# make depend
# make
# make test
# sudo make install
# make clean
