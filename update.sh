#!/bin/bash

STACKS="apache-debian fpm-debian fpm-alpine"

# The earlier tags of kimai needed specific build instructions.  We don't auto build thise.
NUMBER_OF_TAGS_TO_DISCARD=12

# Below here should not need changing
ALLTAGS=$(git ls-remote --tags --refs https://github.com/kevinpapst/kimai2.git | awk --field-separator="/" '{print $3}')
TAGS=$(echo $ALLTAGS | awk -v START=$NUMBER_OF_TAGS_TO_DISCARD '{for(i=START;i<=NF;++i)print $i}')

for TAG in $TAGS; do
  for STACK in $STACKS; do
    mkdir -p tags/$TAG/$STACK
  done
done


