#!/usr/bin/env bash

set -ex

# Get script directory
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

# Get build utilities
source $SCRIPT_DIR/utils.sh


if ! command -v tar &> /dev/null; then
	echo >&2 'error: "tar" not found!'
	exit 1
fi

if [[ -z "${GIT_VERSION}" ]]; then
  echo >&2 'error: GIT_VERSION env. variable must be set to a non-empty value'
  exit 1
fi

(cat /etc/ld.so.conf.d/usr-local.conf 2> /dev/null | grep -q "^/usr/local/lib$") ||
  echo '/usr/local/lib' >> /etc/ld.so.conf.d/usr-local.conf
ldconfig

cd /usr/src

GIT_ROOT="git-${GIT_VERSION}"
GIT_DOWNLOAD_URL="https://mirrors.edge.kernel.org/pub/software/scm/git"

fetch_source "${GIT_ROOT}.tar.gz" "${GIT_DOWNLOAD_URL}"
tar xvzf "${GIT_ROOT}.tar.gz" --no-same-owner

pushd "${GIT_ROOT}"
./configure --prefix=/usr/local --with-curl
make -j"$(nproc)"
make install
popd
rm -rf "${GIT_ROOT}" "${GIT_ROOT}.tar.gz"

ldconfig

# turn the detached message off
git config --global advice.detachedHead false
