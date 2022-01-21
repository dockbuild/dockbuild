#!/usr/bin/env bash

set -ex
set -o pipefail

if ! command -v curl &> /dev/null; then
	echo >&2 'error: "curl" not found!'
	exit 1
fi

if ! command -v gpg &> /dev/null; then
	echo >&2 'error: "gpg" not found!'
	exit 1
fi

GOSU_VERSION=1.12
dpkgArch=$(if test "$(uname -m)" = "x86_64"; then echo amd64; else echo i386; fi)
url="https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${dpkgArch}"
url_key="https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${dpkgArch}.asc"

# download and verify the signature
export GNUPGHOME="$(mktemp -d)"

gpg --keyserver hkp://pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 || \
gpg --keyserver hkp://pgp.key-server.io:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 || \
gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4

echo "Downloading $url"
curl --connect-timeout 30 \
    --max-time 10 \
    --retry 5 \
    --retry-delay 10 \
    --retry-max-time 30 \
    -o /usr/local/bin/gosu -# -SL $url

echo "Downloading $url_key"
curl --connect-timeout 30 \
    --max-time 10 \
    --retry 5 \
    --retry-delay 10 \
    --retry-max-time 30 \
    -o /usr/local/bin/gosu.asc -# -SL $url_key

gpg --verify /usr/local/bin/gosu.asc

# cleanup -- need to kill agent so that there is no race condition for
# agent files in $GNUPGHOME.  Only need to do this on newer distros
# with gpgconf installed supporting the option.
GPGCONF_BIN="$(command -v gpgconf)" || true
if [ -n "$GPGCONF_BIN" ] && [ -x $GPGCONF_BIN ] && [[ $($GPGCONF_BIN --help | grep -- "--kill" || true) != "" ]]; then
	gpgconf --kill gpg-agent
fi

rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc

chmod +x /usr/local/bin/gosu
