#!/bin/bash

set -ex
set -o pipefail

if ! command -v gosu &> /dev/null; then
	echo >&2 'error: "gosu" not found!'
	exit 1
fi

# verify that the binary works
gosu nobody true


cat << EOF >> /usr/bin/sudo
#!/bin/sh
# Emulate the sudo command
exec gosu root:root "\$@"
EOF

chmod +x /usr/bin/sudo

