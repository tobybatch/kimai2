#!/bin/bash -e

function usage {
    echo
    echo "Builds all the images for the specified kimai tag and then tags them and pushes"
    echo "them:"
    echo "  fpm-alpine-X.Y.z-prod, latest, latest-prod"
    echo "  fpm-alpine-X.Y.z-dev"
    echo "  apache-debian-X.Y.z-prod"
    echo "  apache-debian-X.Y.z-dev, latest-dev"
}

USAGE="$0 TAG"
TAG=$1

if [ -z "$TAG" ]; then
  echo $USAGE
  exit 1
fi

if [ "$TAG" == "-h" ] || [ "$TAG" == "help" ] || [ "$TAG" == "--help" ]; then # <-- maybe switch to getopts
  echo $USAGE
  usage
  exit 0
fi

BIN_DIR=$(dirname $0)

$BIN_DIR/build.sh -c $TAG
$BIN_DIR/simple-test.sh $TAG

set -x
docker tag kimai/kimai2:fpm-alpine-${TAG}-prod kimai/kimai2:latest
docker tag kimai/kimai2:fpm-alpine-${TAG}-prod kimai/kimai2:latest-prod
docker tag kimai/kimai2:apache-debian-${TAG}-dev kimai/kimai2:latest-dev
set +x

$BIN_DIR/push.sh $TAG
docker push kimai/kimai2:latest
docker push kimai/kimai2:latest-prod
docker push kimai/kimai2:latest-dev
