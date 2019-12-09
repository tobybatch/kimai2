#!/bin/bash 

if [ -z "$KIMAI" ]; then
    export KIMAI=1.5
fi
export TZ=Europe/London
export DOCKER_BUILDKIT=1

for _KIMAI in $KIMAI master; do
    for VER in dev prod; do
        for BASE in apache-debian fpm-alpine; do
            docker build -t kimai/kimai2:${BASE}-${_KIMAI}-${VER} --build-arg BASE=${BASE} --build-arg VER=${VER} $(dirname $0)/..
        done
    done
done

