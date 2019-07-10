#!/bin/bash

WORKINGDIR=$(dirname $0)
BUILDLOG=$WORKINGDIR/../logs/build-$(date +"%Y%m%d-%H%M").log

function buildimage {
  echo "Builing $1..."
  docker build -t $@ 2>&1 >> $BUILDLOG
  STATUS=$?
  if [ "$STATUS" != 0 ]; then
    echo "Error building $1 image ($STATUS)"
    tail -n 10 build.log
    exit $STATUS
  fi
}

buildimage kimai/kimai2_base --rm $WORKINGDIR/base
docker push kimai/kimai2_base 2>&1 >> $BUILDLOG

TAGS="0.8 0.8.1 0.9 1.0 1.0.1" 
for TAG in $TAGS; do
  buildimage kimai/kimai2:$TAG --build-arg TAG=$TAG $WORKINGDIR
  docker push kimai/kimai2:$TAG 2>&1 >> $BUILDLOG
done
