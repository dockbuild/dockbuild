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

if [[ "${NINJA_VERSION}" == "" ]]; then
  echo >&2 'error: NINJA_VERSION env. variable must be set to a non-empty value'
  exit 1
fi

cd /usr/src

#url="https://github.com/ninja-build/ninja/releases/download/v${NINJA_VERSION}/ninja-linux.zip"
url="https://github.com/Kitware/ninja/releases/download/v${NINJA_VERSION}/ninja-${NINJA_VERSION}_x86_64-linux-gnu.tar.gz"

echo "Downloading $url"
curl -# -LO $url

#unzip ninja-linux.zip
#rm -f ninja-linux.zip
tar --strip-components 1 -xzvf ninja-${NINJA_VERSION}_x86_64-linux-gnu.tar.gz
rm -f ninja-${NINJA_VERSION}_x86_64-linux-gnu.tar.gz

mv ninja /usr/local/bin/

