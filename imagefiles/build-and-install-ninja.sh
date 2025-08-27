#!/usr/bin/env bash

#
# Configure, build and install ninja
#
# Usage:
#
#  build-and-install-ninja.sh [-python /path/to/bin/python]

set -e
set -o pipefail

# Get script directory
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

# Get build utilities
source $SCRIPT_DIR/utils.sh

PYTHON=python
while [ $# -gt 0 ]; do
  case "$1" in
    -python)
      PYTHON=$2
      shift
      ;;
    *)
      echo "Usage: Usage: ${0##*/} [-python /path/to/bin/python]"
      exit 1
      ;;
  esac
  shift
done

if [[ -z "${NINJA_VERSION}" ]]; then
  echo >&2 'error: NINJA_VERSION env. variable must be set to a non-empty value'
  exit 1
fi

# Download
NINJA_DOWNLOAD_URL="https://github.com/ninja-build/ninja/archive/"
NINJA_ROOT="v${NINJA_VERSION}"

fetch_source "${NINJA_ROOT}.tar.gz" "${NINJA_DOWNLOAD_URL}"

# Since the archive name doesn't match the top-level directory, explicitly specify it.
mkdir -p "${NINJA_ROOT}"
tar xvzf "${NINJA_ROOT}.tar.gz"  --strip-components=1 -C "${NINJA_ROOT}"

# Configure, build and install
pushd "${NINJA_ROOT}"
echo "Configuring ninja using [$PYTHON]"
$PYTHON ./configure.py --bootstrap && ./ninja
cp ./ninja /usr/bin/
popd

# Clean
rm -rf "${NINJA_ROOT}" "${NINJA_ROOT}.tar.gz"

