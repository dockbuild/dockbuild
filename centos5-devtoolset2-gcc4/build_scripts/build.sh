#!/bin/bash
# Top-level build script called from Dockerfile

# Stop at any error, show all commands
set -ex

# Python versions to be installed in /opt/$VERSION_NO
CPYTHON_VERSIONS="3.6.4"

# openssl version to build, with expected sha256 hash of .tar.gz
# archive
OPENSSL_ROOT=openssl-1.0.2r
# Get OPENSSL_HASH from https://www.openssl.org/source/
OPENSSL_HASH=ae51d08bba8a83958e894946f15303ff894d75c2b8bbd44a852b64e3fe11d0d6
EPEL_RPM_HASH=0dcc89f9bf67a2a515bad64569b7a9615edc5e018f676a578d5fd0f17d3c81d4
DEVTOOLS_HASH=a8ebeb4bed624700f727179e6ef771dafe47651131a00a78b342251415646acc
# Update to slightly newer, verified Git commit:
# https://github.com/NixOS/patchelf/commit/2a9cefd7d637d160d12dc7946393778fa8abbc58
PATCHELF_VERSION=2a9cefd7d637d160d12dc7946393778fa8abbc58
PATCHELF_HASH=12da4727f09be42ae0b54878e1b8e86d85cb7a5b595731cdc1a0a170c4873c6d
CURL_ROOT=curl_7.52.1
CURL_HASH=a8984e8b20880b621f61a62d95ff3c0763a3152093a9f9ce4287cfd614add6ae
AUTOCONF_ROOT=autoconf-2.69
AUTOCONF_HASH=954bd69b391edc12d6a4a51a2dd1476543da5c6bbf05a95b59dc0dd6fd4c2969
AUTOMAKE_ROOT=automake-1.15
AUTOMAKE_HASH=7946e945a96e28152ba5a6beb0625ca715c6e32ac55f2e353ef54def0c8ed924
LIBTOOL_ROOT=libtool-2.4.6
LIBTOOL_HASH=e3bd4d5d3d025a36c21dd6af7ea818a2afcd4dfc1ea5a17b39d7854bcd0c06e3
SQLITE_AUTOCONF_VERSION=sqlite-autoconf-3210000
# Homebrew saw the same hash: https://github.com/Homebrew/homebrew-core/blob/e3a8622111ecefe444194cade5cca3c69165e26c/Formula/sqlite.rb#L6
SQLITE_AUTOCONF_HASH=d7dd516775005ad87a57f428b6f86afd206cb341722927f104d3f0cf65fbbbe3
GIT_ROOT=2.16.2
GIT_HASH=cbdc2398204c7b7bed64f28265870aabe40dd3cd5c0455f7d315570ad7f7f5c8

# Dependencies for compiling Python that we want to remove from
# the final image after compiling Python
# GPG installed to verify signatures on Python source tarballs.
# [centosbuild]
# We excluded the following packages from PYTHON_COMPILE_DEPS: tk-devel
PYTHON_COMPILE_DEPS="\
zlib-devel \
bzip2-devel \
ncurses-devel \
sqlite-devel \
readline-devel \
gdbm-devel \
db4-devel \
libpcap-devel \
xz-devel \
gpg"
# [/centosbuild]


# Libraries that are allowed as part of the manylinux1 profile
# [centosbuild]
MANYLINUX1_DEPS=""
#MANYLINUX1_DEPS="glibc-devel libstdc++-devel glib2-devel libX11-devel libXext-devel libXrender-devel  mesa-libGL-devel libICE-devel libSM-devel ncurses-devel"

# Alternative repo are setup in Dockerfile

# [/centosbuild]

# Get build utilities
MY_DIR=$(dirname "${BASH_SOURCE[0]}")
source $MY_DIR/build_utils.sh

# [centosbuild]
# See https://unix.stackexchange.com/questions/41784/can-yum-express-a-preference-for-x86-64-over-i386-packages
echo "multilib_policy=best" >> /etc/yum.conf
# [/centosbuild]

# https://hub.docker.com/_/centos/
# "Additionally, images with minor version tags that correspond to install
# media are also offered. These images DO NOT recieve updates as they are
# intended to match installation iso contents. If you choose to use these
# images it is highly recommended that you include RUN yum -y update && yum
# clean all in your Dockerfile, or otherwise address any potential security
# concerns."
# Decided not to clean at this point: https://github.com/pypa/manylinux/pull/129
yum -y update

# EPEL support
yum -y install wget
# https://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
cp $MY_DIR/epel-release-5-4.noarch.rpm .
check_sha256sum epel-release-5-4.noarch.rpm $EPEL_RPM_HASH

# Dev toolset (for LLVM and other projects requiring C++11 support)
wget -q http://people.centos.org/tru/devtools-2/devtools-2.repo
check_sha256sum devtools-2.repo $DEVTOOLS_HASH
mv devtools-2.repo /etc/yum.repos.d/devtools-2.repo
rpm -Uvh --replacepkgs epel-release-5*.rpm
rm -f epel-release-5*.rpm

# Development tools and libraries
yum install -y \
   bzip2 \
   make \
   patch \
   unzip \
   bison \
   yasm \
   automake \
   which \
   file \
   kernel-devel-`uname -r` \
   expat-devel \
   gettext \
   devtoolset-2-binutils \
   devtoolset-2-gcc \
   devtoolset-2-gcc-c++ \
   devtoolset-2-gcc-gfortran \
   ${PYTHON_COMPILE_DEPS}

# [centosbuild]
# We excluded the following packages from the command above: diffutils, cmake28
# [/centosbuild]

# Build an OpenSSL for both curl and the Pythons. We'll delete this at the end.
build_openssl $OPENSSL_ROOT $OPENSSL_HASH
# Install curl so we can have TLS 1.2 in this ancient container.
build_curl $CURL_ROOT $CURL_HASH
hash -r
curl --version
curl-config --features

# Install a git we link against OpenSSL so that we can use TLS 1.2
build_git $GIT_ROOT $GIT_HASH
git version
# [centosbuild]
# turn the detached message off
git config --global advice.detachedHead false
# [/centosbuild]

# Install newest autoconf
build_autoconf $AUTOCONF_ROOT $AUTOCONF_HASH
autoconf --version

# Install newest automake
build_automake $AUTOMAKE_ROOT $AUTOMAKE_HASH
automake --version

# Install newest libtool
build_libtool $LIBTOOL_ROOT $LIBTOOL_HASH
libtool --version

# Install a more recent SQLite3
curl -fsSLO https://sqlite.org/2017/$SQLITE_AUTOCONF_VERSION.tar.gz
check_sha256sum $SQLITE_AUTOCONF_VERSION.tar.gz $SQLITE_AUTOCONF_HASH
tar xfz $SQLITE_AUTOCONF_VERSION.tar.gz
cd $SQLITE_AUTOCONF_VERSION
do_standard_install
cd ..
rm -rf $SQLITE_AUTOCONF_VERSION*

# Compile the latest Python releases.
# (In order to have a proper SSL module, Python is compiled
# against a recent openssl [see env vars above], which is linked
# statically.
mkdir -p /opt/python
build_cpythons $CPYTHON_VERSIONS

PY36_BIN=/opt/python/cp36-cp36m/bin

# Install certifi and auditwheel
$PY36_BIN/pip install --require-hashes -r $MY_DIR/py36-requirements.txt

# [centosbuild]
# We make python36 the default
pushd /usr/local/bin
ln -s ${PY36_BIN}/pip3 pip
ln -s ${PY36_BIN}/idle3 idle
ln -s ${PY36_BIN}/pydoc3 pydoc
ln -s ${PY36_BIN}/python3 python
ln -s ${PY36_BIN}/python3-config python-config
popd
# [/centosbuild]

# Our openssl doesn't know how to find the system CA trust store
#   (https://github.com/pypa/manylinux/issues/53)
# And it's not clear how up-to-date that is anyway
# So let's just use the same one pip and everyone uses
ln -s $($PY36_BIN/python -c 'import certifi; print(certifi.where())') \
      /opt/_internal/certs.pem
# If you modify this line you also have to modify the versions in the
# Dockerfiles:
export SSL_CERT_FILE=/opt/_internal/certs.pem

# [centosbuild]
/imagefiles/build-and-install-openssh.sh
# [/centosbuild]

# Now we can delete our built OpenSSL headers/static libs since we've linked everything we need
rm -rf /usr/local/ssl

# Install patchelf (latest with unreleased bug fixes)
curl -fsSL -o patchelf.tar.gz https://github.com/NixOS/patchelf/archive/$PATCHELF_VERSION.tar.gz
check_sha256sum patchelf.tar.gz $PATCHELF_HASH
tar -xzf patchelf.tar.gz
(cd patchelf-$PATCHELF_VERSION && ./bootstrap.sh && do_standard_install)
rm -rf patchelf.tar.gz patchelf-$PATCHELF_VERSION

ln -s $PY36_BIN/auditwheel /usr/local/bin/auditwheel

# Clean up development headers and other unnecessary stuff for
# final image
# [centosbuild]
#yum -y erase \
#    avahi \
#    bitstream-vera-fonts \
#    freetype \
#    gtk2 \
#    hicolor-icon-theme \
#    libX11 \
#    wireless-tools \
#    ${PYTHON_COMPILE_DEPS}  > /dev/null 2>&1
# [/centosbuild]

yum -y clean all > /dev/null 2>&1

# [centosbuild]
rm -rf /var/cache/yum
# [/centosbuild]

yum list installed

# we don't need libpython*.a, and they're many megabytes
find /opt/_internal -name '*.a' -print0 | xargs -0 rm -f

# Strip what we can -- and ignore errors, because this just attempts to strip
# *everything*, including non-ELF files:
find /opt/_internal -type f -print0 \
    | xargs -0 -n1 strip --strip-unneeded 2>/dev/null || true

# We do not need the Python test suites, or indeed the precompiled .pyc and
# .pyo files. Partially cribbed from:
#    https://github.com/docker-library/python/blob/master/3.4/slim/Dockerfile
find /opt/_internal \
     \( -type d -a -name test -o -name tests \) \
  -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
  -print0 | xargs -0 rm -f

for PYTHON in /opt/python/*/bin/python; do
    # Smoke test to make sure that our Pythons work, and do indeed detect as
    # being manylinux compatible:
    # [centosbuild]
    # $PYTHON $MY_DIR/manylinux1-check.py
    # [/centosbuild]
    # Make sure that SSL cert checking works
    $PYTHON $MY_DIR/ssl-check.py
done

# Fix libc headers to remain compatible with C99 compilers.
find /usr/include/ -type f -exec sed -i 's/\bextern _*inline_*\b/extern __inline __attribute__ ((__gnu_inline__))/g' {} +

