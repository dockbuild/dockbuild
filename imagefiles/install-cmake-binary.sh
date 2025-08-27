#!/usr/bin/env bash

set -ex
set -o pipefail

# Get script directory
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

# Get build utilities
source $SCRIPT_DIR/utils.sh

ARCH="x86_64"

while [ $# -gt 0 ]; do
  case "$1" in
    -32)
      ARCH="x86"
      ;;
    *)
      echo "Usage: Usage: ${0##*/} [-32]"
      exit 1
      ;;
  esac
  shift
done

if ! command -v tar &> /dev/null; then
	echo >&2 'error: "tar" not found!'
	exit 1
fi

if [[ -z "${CMAKE_VERSION}" ]]; then
  echo >&2 'error: CMAKE_VERSION env. variable must be set to a non-empty value'
  exit 1
fi

cd /usr/src

CMAKE_ROOT=cmake-${CMAKE_VERSION}-linux-${ARCH}
CMAKE_DOWNLOAD_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}

echo "Downloading ${CMAKE_DOWNLOAD_URL}/${CMAKE_ROOT}.tar.gz"

fetch_source "${CMAKE_ROOT}.tar.gz" "${CMAKE_DOWNLOAD_URL}"
tar -xzvf "${CMAKE_ROOT}.tar.gz"
rm -f "${CMAKE_ROOT}.tar.gz"

cd "${CMAKE_ROOT}"

rm -rf doc man
rm -rf bin/cmake-gui

find . -type f -exec install -D "{}" "/usr/{}" \;
