#!/bin/bash

# DISTROS="apache-debian fpm-debian fpm-alpine"
WORKDIR=$(dirname $0)
source $WORKDIR/.env
# BUILDLOG=$WORKDIR/logs/build-$(date +"%Y%m%d-%H%M").log
# 
# The earlier tags of kimai needed specific build instructions.  We don't auto build thise.
# NUMBER_OF_TAGS_TO_DISCARD=14

# Below here should not need changing
# ALLTAGS=$(git ls-remote --tags --refs https://github.com/kevinpapst/kimai2.git | awk --field-separator="/" '{print $3}')
# TAGS=$(echo $ALLTAGS | awk -v START=$NUMBER_OF_TAGS_TO_DISCARD '{for(i=START;i<=NF;++i)print $i}')

echo -e "\nBuilding tags master $TAGS\n"

for TAG in master $TAGS; do
  for DISTRO in $DISTROS; do
    echo -n "Building kimai/kimai2:$DISTRO-$TAG... "
    docker build -t kimai/kimai2:$DISTRO-$TAG --build-arg TAG=$TAG --rm $WORKDIR/build/$DISTRO >> $BUILDLOG
    echo Done.
    echo -n "Pushing kimai/kimai2:$DISTRO-$TAG..."
    docker push kimai/kimai2:$DISTRO-$TAG >> $BUILDLOG
    echo Done.
  done
done
