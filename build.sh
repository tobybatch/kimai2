#!/bin/bash

function buildimage {
  echo "Builing $1..."
  docker build -t $@ 2>&1 > build.log
  STATUS=$?
  if [ "$STATUS" != 0 ]; then
    echo "Error building $1 image ($STATUS)"
    tail -n 10 build.log
    exit $STATUS
  fi
}

buildimage kimai/kimai2_base --rm base
docker push kimai/kimai2_base 2>&1 >> build.log

EXIT=0
for x in $(ls tags); do
  TAG=$x
  buildimage kimai/kimai2:$x --build-arg TAG=$x tags/$x
  docker push kimai/kimai2:$x 2>&1 >> build.log
done

buildimage -t kimai/kimai2 .
docker push kimai/kimai2 2>&1 >> build.log
