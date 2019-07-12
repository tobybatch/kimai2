#!/bin/bash

STACKS="apache-debian fpm-debian fpm-alpine"
WORKDIR=$(dirname $0)
BUILDLOG=$WORKDIR/logs/build-$(date +"%Y%m%d-%H%M").log

# The earlier tags of kimai needed specific build instructions.  We don't auto build thise.
NUMBER_OF_TAGS_TO_DISCARD=14

# Below here should not need changing
ALLTAGS=$(git ls-remote --tags --refs https://github.com/kevinpapst/kimai2.git | awk --field-separator="/" '{print $3}')
TAGS=$(echo $ALLTAGS | awk -v START=$NUMBER_OF_TAGS_TO_DISCARD '{for(i=START;i<=NF;++i)print $i}')

echo -e "\nBuilding tags master $TAGS\n"

for TAG in master $TAGS; do
  for STACK in $STACKS; do
    echo -n "Building kimai/kimai2:$STACK-$TAG... "
    docker build -t kimai/kimai2:$STACK-$TAG --build-arg TAG=$TAG --rm $WORKDIR/build/$STACK >> $BUILDLOG
    echo Done.
    echo -n "Pushing kimai/kimai2:$STACK-$TAG..."
    docker push kimai/kimai2:$STACK-$TAG >> $BUILDLOG
    echo Done.
  done
done
