#!/bin/bash 

function usage {
    echo
    echo " -t The timezone, e.g. Europe/London"
    echo " -c Use the docker cache, default behaviour is to add --nocache"
    echo " -h Show help"
}

export DOCKER_BUILDKIT=1
export TZ=Europe/London
NOCACHE="--no-cache"

USAGE="$0 [-t TIMEZONE] [-c] [-h] VERSIONS"

while getopts "t:ch" options; do
    case $options in
        t) export TZ="$OPTARG";;
        c) unset NOCACHE;;
        h) echo $USAGE; usage; exit 0;;
    esac
done

shift $((OPTIND-1))
export KIMAIS=$@

echo $KIMAIS

for KIMAI in $KIMAIS master; do
    for STAGE_NAME in dev prod; do
        for BASE in apache-debian fpm-alpine; do
            docker build $NOCACHE -t kimai/kimai2:${BASE}-${KIMAI}-${STAGE_NAME} --build-arg BASE=${BASE} --target=${STAGE_NAME} $(dirname $0)/..
        done
    done
done
