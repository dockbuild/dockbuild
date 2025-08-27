#!/bin/bash
# Top-level build script called from Dockerfile

set -ex

# Get script directory
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

# Get build utilities
source $SCRIPT_DIR/utils.sh

if ! command -v tar &> /dev/null; then
  echo >&2 'error: "tar" not found!'
  exit 1
fi

if [[ "${NINJA_VERSION}" == "" ]]; then
  echo >&2 'error: NINJA_VERSION env. variable must be set to a non-empty value'
  exit 1
fi

cd /usr/src

# Download
#NINJA_DOWNLOAD_URL="https://github.com/ninja-build/ninja/releases/download/v${NINJA_VERSION}/"
#NINJA_ROOT="ninja-linux"
#NINJA_ARCHIVE="${NINJA_ROOT}.zip"
NINJA_DOWNLOAD_URL="https://github.com/Kitware/ninja/releases/download/v${NINJA_VERSION}"
NINJA_ROOT="ninja-${NINJA_VERSION}_x86_64-linux-gnu"
NINJA_ARCHIVE="${NINJA_ROOT}.tar.gz"

echo "Downloading ${NINJA_DOWNLOAD_URL}/${NINJA_ARCHIVE}"
fetch_source "${NINJA_ARCHIVE}" "${NINJA_DOWNLOAD_URL}"

# Since the archive name may not match the top-level directory, explicitly specify it.
mkdir -p "${NINJA_ROOT}"
tar xvzf "${NINJA_ARCHIVE}" --strip-components=1 -C "${NINJA_ROOT}"
pushd "${NINJA_ROOT}"
mv ninja /usr/local/bin/
popd
rm -rf "${NINJA_ROOT}" "${NINJA_ARCHIVE}"

hash -r
ninja --version
