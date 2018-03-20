#!/bin/bash

set -ex

if ! command -v curl &> /dev/null; then
	echo >&2 'error: "curl" not found!'
	exit 1
fi

if ! command -v tar &> /dev/null; then
	echo >&2 'error: "tar" not found!'
	exit 1
fi

if [[ "${CMAKE_VERSION}" == "" ]]; then
  echo >&2 'error: CMAKE_VERSION env. variable must be set to a non-empty value'
  exit 1
fi

cd /usr/src

CMAKE_VERSION_XY=$(echo ${CMAKE_VERSION} | sed -r 's/\.[0-9]+(\-rc[0-9])?$//')

url=https://cmake.org/files/v${CMAKE_VERSION_XY}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz
echo "Downloading $url"
curl -# -LO $url

tar -xzvf cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz
rm -f cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz

cd cmake-${CMAKE_VERSION}-Linux-x86_64

rm -rf doc man
rm -rf bin/cmake-gui

ln -s $(pwd)/bin/cmake /usr/local/bin/cmake
ln -s $(pwd)/bin/ctest /usr/local/bin/ctest
ln -s $(pwd)/bin/cpack /usr/local/bin/cpack
ln -s $(pwd)/bin/ccmake /usr/local/bin/ccmake
