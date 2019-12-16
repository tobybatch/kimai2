#!/bin/bash 

if [ -z "$KIMAI" ]; then
    export KIMAI=1.5
fi
export TZ=Europe/London
export DOCKER_BUILDKIT=1

for _KIMAI in $KIMAI master; do
    for STAGE_NAME in dev prod; do
        for BASE in apache-debian fpm-alpine; do
            docker build -t kimai/kimai2:${BASE}-${_KIMAI}-${STAGE_NAME} --build-arg BASE=${BASE} --target=${STAGE_NAME} $(dirname $0)/..
        done
    done
done

