#!/usr/bin/env bash
# Top-level build script called from Dockerfile

set -ex
set -o pipefail

# Get script directory
SCRIPT_DIR=$(dirname "${BASH_SOURCE[0]}")

# Get build utilities
source $SCRIPT_DIR/utils.sh
source $SCRIPT_DIR/dockbuild-utils.sh

# copied from https://github.com/pypa/manylinux/blob/9e7b93e8996f88b0ca6ef43f1ccf6642d9f93d85/docker/build_scripts/install-automake.sh

# Install newest automake
check_var "${AUTOMAKE_ROOT}"
check_var "${AUTOMAKE_HASH}"
check_var "${AUTOMAKE_DOWNLOAD_URL}"

SYSTEM_ACLOCAL="$(which aclocal)"

fetch_source "${AUTOMAKE_ROOT}.tar.gz" "${AUTOMAKE_DOWNLOAD_URL}"
check_sha256sum "${AUTOMAKE_ROOT}.tar.gz" "${AUTOMAKE_HASH}"
tar -xzf "${AUTOMAKE_ROOT}.tar.gz"
pushd "${AUTOMAKE_ROOT}"
DESTDIR=/manylinux-rootfs do_standard_install
popd
rm -rf "${AUTOMAKE_ROOT}" "${AUTOMAKE_ROOT}.tar.gz"

# Strip what we can
strip_ /manylinux-rootfs

# Install
cp -rlf /manylinux-rootfs/* /

# Remove temporary rootfs
rm -rf /manylinux-rootfs

# keep system aclocal files with local automake
"${SYSTEM_ACLOCAL}" --print-ac-dir >> "/usr/local/share/aclocal/dirlist"

hash -r
automake --version
