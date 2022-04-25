#!/usr/bin/sh
mkdir -p build-taglib
cd build-taglib
cmake ../taglib-1.12 -DCMAKE_C_COMPILER=xfuzz-cc -DCMAKE_CXX_COMPILER=xfuzz-c++ -DCMAKE_CXX_COMPILER_ID=Clang -DCMAKE_CXX_COMPILER_VERSION=12.0.0 -DCMAKE_CXX_STANDARD_COMPUTED_DEFAULT=14
make VERBOSE=1 -j
taglib=taglib
LIBRARY_PATH_=$(pwd)/$taglib
xfuzz-c++  -I. -I../taglib-1.12/taglib -I../taglib-1.12/taglib/toolkit -I../taglib-1.12/taglib/ape -I../taglib-1.12/taglib/mpeg -I../taglib-1.12/taglib/mpeg/id3v1 -I../taglib-1.12/taglib/mpeg/id3v2 -I../taglib-1.12/taglib/mpeg/id3v2/frames -I../taglib-1.12/bindings/c -L$LIBRARY_PATH_ ../main.cpp -ltag -lz -o taglib-reader-xfuzz 
