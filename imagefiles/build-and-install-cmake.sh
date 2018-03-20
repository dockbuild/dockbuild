#!/bin/bash

set -ex

if ! command -v git &> /dev/null; then
	echo >&2 'error: "git" not found!'
	exit 1
fi

if [[ "${CMAKE_VERSION}" == "" ]]; then
  echo >&2 'error: CMAKE_VERSION env. variable must be set to a non-empty value'
  exit 1
fi

cd /usr/src

git clone git://cmake.org/cmake.git CMake

(cd CMake && git checkout v$CMAKE_VERSION)

mkdir /usr/src/CMake-build
cd /usr/src/CMake-build

/usr/src/CMake/bootstrap \
  --parallel=$(grep -c processor /proc/cpuinfo) \
  --prefix=/usr/src/cmake-$CMAKE_VERSION
make -j$(grep -c processor /proc/cpuinfo)

./bin/cmake \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DCMAKE_USE_OPENSSL:BOOL=ON \
  -DOPENSSL_ROOT_DIR:PATH=/usr/local/ssl \
  .
make -j$(grep -c processor /proc/cpuinfo) install

cd /usr/src/cmake-$CMAKE_VERSION
rm -rf doc man

ln -s $(pwd)/bin/cmake /usr/local/bin/cmake
ln -s $(pwd)/bin/ctest /usr/local/bin/ctest
ln -s $(pwd)/bin/cpack /usr/local/bin/cpack
ln -s $(pwd)/bin/ccmake /usr/local/bin/ccmake

rm -rf /usr/src/CMake*
