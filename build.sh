#!/bin/bash

WORKDIR=$(dirname $0)
source $WORKDIR/.env

$WORKDIR/legacy/build.sh

echo -e "\nBuilding tags master $TAGS\n"

for TAG in master $TAGS; do
  for DISTRO in $DISTROS; do
    echo -n "Building kimai/kimai2:$DISTRO-$TAG... "
    docker build -t kimai/kimai2:$DISTRO-$TAG --build-arg TAG=$TAG --rm $WORKDIR/build/$DISTRO
    echo Done.
    echo -n "Pushing kimai/kimai2:$DISTRO-$TAG..."
    # docker push kimai/kimai2:$DISTRO-$TAG
    echo Done.
  done
done
