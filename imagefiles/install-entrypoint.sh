#!/bin/bash

set -ex

if ! command -v curl &> /dev/null; then
	echo >&2 'error: "curl" not found!'
	exit 1
fi

mkdir -p /dockcross

cd /dockcross

for helper_script in dockcross sudo.sh entrypoint.sh; do
  url="https://raw.githubusercontent.com/dockcross/dockcross/master/imagefiles/$helper_script"
  echo "Downloading $url"
  curl -# -LO $url
done

chmod +x entrypoint.sh

mv sudo.sh /usr/bin/sudo
chmod +x /usr/bin/sudo

