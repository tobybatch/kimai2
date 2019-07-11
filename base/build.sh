#!/bin/bash

WORKINGDIR=$(dirname $0)
BUILDLOG=$WORKINGDIR/../logs/build-$(date +"%Y%m%d-%H%M").log

cd $WORKINGDIR
for x in $(find */*); do
  TAG=$(dirname $x);
  IMG=kimai/kimai2_base:$TAG
  echo Building $TAG ...
  docker build --rm -t $IMG $TAG
  docker push $IMG
done

cd - > /dev/null
