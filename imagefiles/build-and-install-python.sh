#!/bin/bash

set -ex

if ! command -v curl &> /dev/null; then
	echo >&2 'error: "curl" not found!'
	exit 1
fi

if ! command -v tar &> /dev/null; then
	echo >&2 'error: "tar" not found!'
	exit 1
fi

if [[ "${PYTHON_VERSION}" == "" ]]; then
  echo >&2 'error: PYTHON_VERSION env. variable must be set to a non-empty value'
  exit 1
fi

cd /usr/src

url="https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz"
echo "Downloading $url"
curl -# -LO $url

tar xvzf Python-${PYTHON_VERSION}.tgz
rm -rf Python-${PYTHON_VERSION}.tgz

(cat /etc/ld.so.conf.d/usr-local.conf 2> /dev/null | grep -q "^/usr/local/lib$") ||
  echo '/usr/local/lib' >> /etc/ld.so.conf.d/usr-local.conf
ldconfig

pushd Python-${PYTHON_VERSION}
./configure --enable-shared
make -j$(grep -c processor /proc/cpuinfo)
make install
popd

ldconfig

rm -rf Python-${PYTHON_VERSION}

cd /usr/local/bin
ln -s $(which pip3) pip
ln -s $(which idle3) idle
ln -s $(which pydoc3) pydoc
ln -s $(which python3) python
ln -s $(which python3-config) python-config

# Copied from https://github.com/docker-library/python/blob/master/3.6/stretch/slim/Dockerfile
(find /usr/local/lib -depth \
    \( -type d -a -name test -o -name tests \) \
 -o \( -type f -a -name '*.pyc' -o -name '*.pyo' \) \
 -exec rm -rf '{}' +;)

#
# we don't need libpython*.a, and they're many megabytes
#
find /usr/local/lib -name '*.a' -print0 | xargs -0 rm -f

