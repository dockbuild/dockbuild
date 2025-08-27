#!/usr/bin/env bash
#
# Configure, build and install libtool

set -ex
set -o pipefail

# Get script directory
MY_DIR=$(dirname "${BASH_SOURCE[0]}")

# Get build utilities
source $MY_DIR/utils.sh

# Copied from https://github.com/pypa/manylinux/blob/70130bb463225012f71e13b7c5f8a6c69b223e56/docker/build_scripts/build_utils.sh
function strip_ {
    # Strip what we can -- and ignore errors, because this just attempts to strip
    # *everything*, including non-ELF files:
    find "$1" -type f -print0 | xargs -0 -n1 strip --strip-unneeded 2>/dev/null || true
}

# copied from https://github.com/pypa/manylinux/blob/70130bb463225012f71e13b7c5f8a6c69b223e56/docker/build_scripts/build_utils.sh
function do_standard_install {
    # use all flags used by ubuntu 20.04 for hardening builds, dpkg-buildflags --export
    # other flags mentioned in https://wiki.ubuntu.com/ToolChain/CompilerFlags can't be
    # used because the distros used here are too old
    MANYLINUX_CPPFLAGS="-Wdate-time -D_FORTIFY_SOURCE=2"
    MANYLINUX_CFLAGS="-g -O2 -Wall -fdebug-prefix-map=/=. -fstack-protector-strong -Wformat -Werror=format-security"
    MANYLINUX_CXXFLAGS="-g -O2 -Wall -fdebug-prefix-map=/=. -fstack-protector-strong -Wformat -Werror=format-security"
    MANYLINUX_LDFLAGS="-Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now"

    ./configure "$@" CPPFLAGS="${MANYLINUX_CPPFLAGS}" CFLAGS="${MANYLINUX_CFLAGS}" "CXXFLAGS=${MANYLINUX_CXXFLAGS}" LDFLAGS="${MANYLINUX_LDFLAGS}" > /dev/null
    make > /dev/null
    make install > /dev/null
}

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
