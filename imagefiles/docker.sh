#!/bin/bash

#
# Docker wrapper
#
# (1) Ignore "--cache-from" argument if it is not supported.
#

declare -a ARGS

while [ $# != 0 ]; do

    case $1 in

        --cache-from*)
            docker help build  | grep -- "--cache-from" > /dev/null
            result=$?
            if [[ $result -eq 0 ]]; then
              ARGS[${#ARGS[*]}]=$1
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
