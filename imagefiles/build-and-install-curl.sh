#!/usr/bin/env bash

set -ex

# Get script directory
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

# Get build utilities
source $SCRIPT_DIR/utils.sh

#
# Function 'do_curl_build' and 'build_curl'
# copied from https://github.com/pypa/manylinux/tree/master/docker/build_scripts
#

if [[ -z "${CURL_VERSION}" ]]; then
  echo >&2 'error: CURL_VERSION env. variable must be set to a non-empty value'
  exit 1
fi

if [[ -z "${CURL_HASH}" ]]; then
  echo >&2 'error: CURL_HASH env. variable must be set to a non-empty value'
  exit 1
fi

CURL_ROOT="${CURL_VERSION}"
CURL_DOWNLOAD_URL=https://curl.haxx.se/download

function do_curl_build {
    # We do this shared to avoid obnoxious linker issues where git couldn't
    # link properly. If anyone wants to make this build statically go for it.
    LIBS=-ldl CFLAGS=-Wl,--exclude-libs,ALL ./configure --with-ssl --disable-static > /dev/null
    make -j"$(nproc)" > /dev/null
    make install > /dev/null
}

cd /usr/src

fetch_source "${CURL_ROOT}.tar.gz" "${CURL_DOWNLOAD_URL}"
check_sha256sum "${CURL_ROOT}.tar.gz" "${CURL_HASH}"

tar -zxf "${CURL_ROOT}.tar.gz"
pushd "${CURL_ROOT}"
do_curl_build
popd
rm -rf "${CURL_ROOT}" "${CURL_ROOT}.tar.gz"

(cat /etc/ld.so.conf.d/usr-local.conf 2> /dev/null | grep -q "^/usr/local/lib$") ||
  echo '/usr/local/lib' >> /etc/ld.so.conf.d/usr-local.conf
ldconfig

