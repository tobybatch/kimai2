#!/bin/bash -e

WORKDIR=$(dirname $0)
LOGDIR=$(realpath $WORKDIR)/../logs

cd $WORKDIR
for x in $(find */*); do
  LOGNAME=$LOGDIR/$(dirname $x).log
  echo "## $(date)" > $LOGNAME
  TAG=$(dirname $x);
  IMG=kimai/kimai2_base:$TAG
  echo -n "        Building $TAG ... (docker build --rm -t $IMG $TAG) ... "
  DOCKER_BUILDKIT=1 docker build --rm -t $IMG $TAG > $LOGNAME
  echo Done.
done

cd - > /dev/null
