#!/bin/bash

set -ex

if ! command -v curl &> /dev/null; then
	echo >&2 'error: "curl" not found!'
	exit 1
fi

if ! command -v gpg &> /dev/null; then
	echo >&2 'error: "gpg" not found!'
	exit 1
fi

GOSU_VERSION=1.10

gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4

url="https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64"
echo "Downloading $url"
curl -o /usr/local/bin/gosu -# -SL $url

url="https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64.asc"
echo "Downloading $url"
curl -o /usr/local/bin/gosu.asc -# -SL $url

gpg --verify /usr/local/bin/gosu.asc

rm /usr/local/bin/gosu.asc
rm -r /root/.gnupg/ || echo "/root/.gnupg/ not found"

chmod +x /usr/local/bin/gosu
