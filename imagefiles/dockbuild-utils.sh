#!/usr/bin/env bash

set -e

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
