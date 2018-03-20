#!/bin/bash

#
# Docker wrapper
#
# (1) Ignore "--cache-from" argument if it is not supported.
# (2) Update --cache-from values to ignore images that do not exist locally or on the public registry
#

#
# Usage: docker_tag_exists_locally image[:tag]
#
function docker_tag_exists_locally {
  image_name=${1##library/} # Strip "library/" suffix
  found=$(docker images -q "$image_name" 2> /dev/null; return $?)
  [[ $found == "" ]] && return 1 || return 0
}

#
# Usage: docker_tag_exists_dockerhub image[:tag]
#
function docker_tag_exists_dockerhub {
  # get image org, repo and tag
  image_name="${1%:*}"
  image_tag="${1#*:}"
  if [ "$image_tag" == "$1" ]; then
    image_tag="latest"
  fi
  image_org="${image_name%/*}"
  image_repo="${image_name#*/}"
  if [ "$image_org" == "$image_name" ]; then
    image_org="library"
  fi
  curl -i https://registry.hub.docker.com/v2/repositories/$image_org/$image_repo/tags/$image_tag/ 2> /dev/null | head -n1 | grep 200 > /dev/null
  result=$?
  return $result
}

#
# Usage: join_by "," "item1 item2 item3"
#
function join_by { local IFS="$1"; shift; echo "$*"; }

declare -a ARGS

while [ $# != 0 ]; do

    case $1 in

        --cache-from*)
            docker help build  | grep -- "--cache-from" > /dev/null
            result=$?
            if [[ $result -eq 0 ]]; then
              # get list of expected cache images
              cache_from=$(echo $1 | cut -f2 -d"=")
              # for each image, check if it exists locally or on dockerhub, if it does keep the parameter
              declare -a images_cache_from
              for image in $(echo $cache_from | sed "s/,/ /"); do
                docker_tag_exists_locally "$image" || docker_tag_exists_dockerhub "$image"
                if [[ $? -eq 0 ]]; then
                  images_cache_from[${#images_cache_from[*]}]=$image
                else
                  echo "dockbuild: ignoring cache-from [$image] image: does not exist locally or on dockerhub"
                fi
              done
              updated_cache_from=$(join_by "," "${images_cache_from[@]}")
              if [[ $updated_cache_from != "" ]]; then
                ARGS[${#ARGS[*]}]="--cache-from=$updated_cache_from"
              fi
            else
              echo "dockbuild: docker: ignoring unsupported --cache-from argument"
            fi
            shift
            ;;

        *)
            ARGS[${#ARGS[*]}]=$1
            shift
            ;;

    esac
done

exec docker "${ARGS[@]}"
