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
url="https://github.com/dockbuild/ninja-jobserver/releases/download/v${NINJA_VERSION}-jobserver/ninja-jobserver-linux.zip"

echo "Downloading $url"
curl -# -LO $url

#unzip ninja-linux.zip
#rm -f ninja-linux.zip
unzip ninja-jobserver-linux.zip
rm -f ninja-jobserver-linux.zip

mv ninja /usr/local/bin/

