#!/usr/bin/env bash

thirdparty_module_name='test'

upstream_git_url='git://github.com/dockcross/dockcross'
upstream_git_branch='master'
github_compare=true

snapshot_author_name='Dockcross Upstream'
snapshot_author_email='matt.mccormick@kitware.com'

snapshot_redact_cmd=''
snapshot_relative_path='.'
snapshot_paths='
  test
  '

source "${BASH_SOURCE%/*}/../utilities/maintenance/UpdateThirdPartyFromUpstream.sh"
update_from_upstream
