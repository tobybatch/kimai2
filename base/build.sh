#!/bin/bash -e

WORKINGDIR=$(dirname $0)

cd $WORKINGDIR
for x in $(find */*); do
  TAG=$(dirname $x);
  IMG=kimai/kimai2_base:$TAG
  echo -e "\n### Building $TAG ... (docker build --rm -t $IMG $TAG) ..."
  docker build --rm -t $IMG $TAG > /dev/null
  docker push $IMG > /dev/null
done

cd - > /dev/null
