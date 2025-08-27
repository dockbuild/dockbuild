#!/usr/bin/env bash
# Top-level build script called from Dockerfile

set -ex
set -o pipefail

# Get script directory
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

# Get build utilities
source $SCRIPT_DIR/utils.sh
source $SCRIPT_DIR/dockbuild-utils.sh

# copied from https://github.com/pypa/manylinux/blob/70130bb463225012f71e13b7c5f8a6c69b223e56/docker/build_scripts/install-libtool.sh

# Install newest libtool
check_var "${LIBTOOL_ROOT}"
check_var "${LIBTOOL_HASH}"
check_var "${LIBTOOL_DOWNLOAD_URL}"

fetch_source "${LIBTOOL_ROOT}.tar.gz" "${LIBTOOL_DOWNLOAD_URL}"
check_sha256sum "${LIBTOOL_ROOT}.tar.gz" "${LIBTOOL_HASH}"
tar -xzf "${LIBTOOL_ROOT}.tar.gz"
pushd "${LIBTOOL_ROOT}"
DESTDIR=/manylinux-rootfs do_standard_install
popd
rm -rf "${LIBTOOL_ROOT}" "${LIBTOOL_ROOT}.tar.gz"

# Strip what we can
strip_ /manylinux-rootfs

# Install
cp -rlf /manylinux-rootfs/* /

# Remove temporary rootfs
rm -rf /manylinux-rootfs/

hash -r
libtoolize --version
