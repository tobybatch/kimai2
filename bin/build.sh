#!/bin/bash -e

function usage {
    echo
    echo "VERSIONS is a space delimited list of branches and or tags."
    echo "e.g. 1.7 fixes/foo"
    echo
    echo " -b The images bases, e.g. apache-debian fpm-alpine"
    echo " -t The timezone, e.g. Europe/London"
    echo " -s The stages, e.g. dev prod"
    echo " -k Do not use Docker Build Kit"
    echo " -c Use the docker cache, default behaviour is to add --nocache"
    echo " -h Show help"
}

export DOCKER_BUILDKIT=1
export TZ=Europe/London
export STAGES="dev prod"
export BASES="apache-debian fpm-alpine"
NOCACHE="--no-cache"

USAGE="$0 [-t TIMEZONE] [-b BASES] [-s STAGES] [-k] [-c] [-h] VERSIONS"

while getopts "b:t:s:kch" options; do
    case $options in
        b) export BASES="$OPTARG";;
        s) export STAGES="$OPTARG";;
        t) export TZ="$OPTARG";;
        k) unset DOCKER_BUILDKIT;;
        c) unset NOCACHE;;
        h) echo $USAGE; usage; exit 0;;
    esac
done

shift $((OPTIND-1))
export KIMAIS=$@

if [ ! -z "$1" ] && [ -z "$KIMAIS" ]; then
    KIMAIS=$@
fi

echo "Building, $KIMAIS for $STAGES and $BASES"

for KIMAI in $KIMAIS; do
    for STAGE_NAME in $STAGES; do
        for BASE in $BASES; do
            echo "*************************************"
            echo "* Building $KIMAI for $STAGE_NAME and $BASE"
            echo "*************************************"
            docker build $NOCACHE -t kimai/kimai2:${BASE}-${KIMAI}-${STAGE_NAME} --build-arg KIMAI=${KIMAI} --build-arg BASE=${BASE} --build-arg TZ=${TZ} --target=${STAGE_NAME} $(dirname $0)/..
        done
    done
done
