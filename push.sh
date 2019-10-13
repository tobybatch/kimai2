#!/bin/bash -e

WORKDIR=$(dirname $0)
source $WORKDIR/.env

echo ">>> Pushing base images"
for x in $(find */*); do
  TAG=$(dirname $x);
  IMG=kimai/kimai2_base:$TAG
  docker push $IMG $TAG
done


echo ">>> Pushing development image"
docker push kimai/kimai2:dev

# No need to rebuild every time
# echo -e "\nBuilding legacy images\n"
# $WORKDIR/legacy/build.sh

echo ">>> Pushing tags master $TAGS\n"

for TAG in master $TAGS; do
  for DISTRO in $DISTROS; do
    echo "Pushing kimai/kimai2:$DISTRO-$TAG..."
    docker push kimai/kimai2:$DISTRO-$TAG
  done
done
