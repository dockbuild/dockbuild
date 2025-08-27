#!/usr/bin/env bash
# Top-level build script called from Dockerfile

set -ex
set -o pipefail

# Get script directory
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

# Get build utilities
source $SCRIPT_DIR/utils.sh
source $SCRIPT_DIR/dockbuild-utils.sh

# Install newest make
check_var "${MAKE_ROOT}"
check_var "${MAKE_HASH}"
check_var "${MAKE_DOWNLOAD_URL}"

fetch_source "${MAKE_ROOT}.tar.gz" "${MAKE_DOWNLOAD_URL}"
check_sha256sum "${MAKE_ROOT}.tar.gz" "${MAKE_HASH}"
tar -xzf "${MAKE_ROOT}.tar.gz"
pushd "${MAKE_ROOT}"
DESTDIR=/manylinux-rootfs do_standard_install
popd
rm -rf "${MAKE_ROOT}" "${MAKE_ROOT}.tar.gz"

# Strip what we can
strip_ /manylinux-rootfs

# Install
cp -rlf /manylinux-rootfs/* /

# Remove temporary rootfs
rm -rf /manylinux-rootfs

hash -r
make --version
