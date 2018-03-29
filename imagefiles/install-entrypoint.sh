#!/bin/bash

set -ex

if ! command -v curl &> /dev/null; then
	echo >&2 'error: "curl" not found!'
	exit 1
fi

# gosu is required to use "entrypoint.sh"
if ! command -v gosu &> /dev/null; then
	echo >&2 'error: "gosu" not found!'
	exit 1
fi

mkdir -p /dockcross

cd /dockcross

DOCKCROSS_GIT_SHA=9966e1aed7c6dba168a1ee90efb430de730914b3

for helper_script in dockcross sudo.sh entrypoint.sh; do
  url="https://raw.githubusercontent.com/dockcross/dockcross/${DOCKCROSS_GIT_SHA}/imagefiles/$helper_script"
  echo "Downloading $url"
  curl -# -LO $url
done

chmod +x entrypoint.sh

mv sudo.sh /usr/bin/sudo
chmod +x /usr/bin/sudo

