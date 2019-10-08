#!/bin/bash -e

WORKDIR=$(dirname $0)
source $WORKDIR/.env

echo -e "\nBuilding base images\n"
$WORKDIR/base/build.sh

echo -e "\nBuilding developpment image\n"
docker build -t kimai/kimai2:dev $WORKDIR
docker push kimai/kimai2:dev

# No need to rebuild every time
# echo -e "\nBuilding legacy images\n"
# $WORKDIR/legacy/build.sh

echo -e "\n########################################\nBuilding tags master $TAGS\n"

for TAG in master $TAGS; do
  for DISTRO in $DISTROS; do
    echo -ne "\n### Building kimai/kimai2:$DISTRO-$TAG... "
    docker build -t kimai/kimai2:$DISTRO-$TAG --build-arg TAG=$TAG $WORKDIR/build/$DISTRO > $WORKDIR/logs/${TAG}${DISTRO}.log
    echo Done.
    echo -n "Pushing kimai/kimai2:$DISTRO-$TAG..."
    docker push kimai/kimai2:$DISTRO-$TAG
    echo Done.
  done
done
