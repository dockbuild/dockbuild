#!/usr/bin/env bash

thirdparty_module_name='imagefiles'

upstream_git_url='https://github.com/dockcross/dockcross'
upstream_git_branch='master'
github_compare=true

snapshot_author_name='Dockcross Upstream'
snapshot_author_email='matt.mccormick@kitware.com'

snapshot_redact_cmd=''
snapshot_relative_path='.'
snapshot_paths='
  imagefiles/build-and-install-curl.sh
  imagefiles/build-and-install-git.sh
  imagefiles/build-and-install-ninja.sh
  imagefiles/build-and-install-openssh.sh
  imagefiles/build-and-install-openssl.sh
  imagefiles/dockcross.sh
  imagefiles/entrypoint.sh
  imagefiles/install-cmake-binary.sh
  imagefiles/install-gosu-binary.sh
  imagefiles/install-gosu-binary-wrapper.sh
  imagefiles/utils.sh
  '

source "${BASH_SOURCE%/*}/../utilities/maintenance/UpdateThirdPartyFromUpstream.sh"
update_from_upstream
