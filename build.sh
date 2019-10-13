#!/bin/bash -e

WORKDIR=$(dirname $0)
LOGDIR=$(realpath $WORKDIR)/logs

source $WORKDIR/.env

echo ">>> Building base images"
$WORKDIR/base/build.sh

echo ">>> Building developpment image"
docker build -t kimai/kimai2:dev $WORKDIR > $LOGDIR/dev.log

# No need to rebuild every time
# echo "Building legacy images"
# $WORKDIR/legacy/build.sh

echo ">>> Building tags master $TAGS"

source $WORKDIR/.env
for TAG in master $TAGS; do
  for DISTRO in $DISTROS; do
    TAGNAME=$DISTRO-$TAG
    echo -en "        Building kimai/kimai2:$TAGNAME ... "
    docker build \
      -t kimai/kimai2:$TAGNAME \
      --build-arg TAG=$TAG $WORKDIR/build/$DISTRO \
      > $WORKDIR/logs/$TAGNAME.log > $LOGDIR/$DISTRO.log
    echo Done.
  done
done
