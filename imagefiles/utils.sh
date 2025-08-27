#!/usr/bin/env bash

set -e

# Copied from https://github.com/pypa/manylinux/blob/master/docker/build_scripts/build_utils.sh
function check_var {
    if [ -z "$1" ]; then
        echo "required variable not defined"
        exit 1
    fi
}

# Copied from https://github.com/pypa/manylinux/blob/master/docker/build_scripts/build_utils.sh
function check_sha256sum {
    local fname=$1
    check_var ${fname}
    local sha256=$2
    check_var ${sha256}

    echo "${sha256}  ${fname}" > ${fname}.sha256
    sha256sum -c ${fname}.sha256
    rm -f ${fname}.sha256
}

function fetch_source {
    if ! command -v curl &> /dev/null; then
      echo >&2 'error: "curl" not found!'
      exit 1
    fi
    local file=$1
    check_var "${file}"
    local url=$2
    check_var "${url}"
    curl --fail \
         --location \
         --silent \
         --show-error \
         --connect-timeout 30 --max-time 10 \
         --retry 5 --retry-delay 10 --retry-max-time 30 \
         -o "${file}" ${url}/${file}
}
