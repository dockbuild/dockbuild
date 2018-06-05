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
CMAKE_ROOT=cmake-${CMAKE_VERSION}-Linux-x86_64

url=https://cmake.org/files/v${CMAKE_VERSION_XY}/${CMAKE_ROOT}.tar.gz
echo "Downloading $url"
curl -# -LO $url

tar -xzvf ${CMAKE_ROOT}.tar.gz
rm -f ${CMAKE_ROOT}.tar.gz

cd ${CMAKE_ROOT}

rm -rf doc man
rm -rf bin/cmake-gui

find . -type f -exec install -D "{}" "/usr/{}" \;
