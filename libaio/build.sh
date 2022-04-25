#!/usr/bin/sh
cd ./libaio-libaio-0.3.113/src 
make CC=xfuzz-cc CXX=xfuzz-c++ VERBOSE=1 -j
cd ../..
mkdir -p build-libaio
make CC=xfuzz-cc CXX=xfuzz-c++ VERBOSE=1 -j
mv libaio-read-write-xfuzz ./build-libaio