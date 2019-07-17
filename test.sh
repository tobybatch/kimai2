#!/bin/bash

source $(dirname $0)/.env

UNIQ=$(</dev/urandom tr -dc 'a-z' | head -c16)
echo "UNIQ=UNIQ"

function main {
  # Test build legacy base image
  echo Building legacy base images
  env NAME=${UNIQ}_legacy:base DOCKER_DIR=$(dirname $0)/legacy/base TAG=NA bats --tap tests/build.bats

  # Test build legacy images
  for TAG in $LEGACY_TAGS; do
    echo -e "\n\nBuilding legacy $TAG image"
    env NAME=${UNIQ}_legacy:${TAG} DOCKER_DIR=$(dirname $0)/legacy TAG=$TAG bats --tap tests/build.bats
    echo Testing legacy $TAG image
    env NAME=${UNIQ}_legacy:${TAG} DOCKER_DIR=$(dirname $0)/legacy TAG=$TAG bats --tap tests/run-and-test.bats
  done

  # Build base images
  for DISTRO in $DISTROS; do
    echo -e "\nBuilding $DISTRO base image"
    env NAME=${UNIQ}_test_$DISTRO DOCKER_DIR=$(dirname $0)/base/$DISTRO TAG=NA bats --tap tests/build.bats
  done

  # Build the distro images
  for TAG in master $TAGS; do
    for DISTRO in $DISTROS; do
      echo -e "\nBuilding $DISTRO $TAG image"
      env NAME=${UNIQ}_$DISTRO:${TAG} DOCKER_DIR=$(dirname $0)/build/$DISTRO TAG=$TAG bats --tap tests/build.bats
      echo Testing $DISTRO $TAG image
      env NAME=${UNIQ}_$DISTRO:${TAG} DOCKER_DIR=$(dirname $0)/build/$DISTRO TAG=$TAG bats --tap tests/run-and-test.bats
    done
  done

  # Clean up

  # Remove all legacy base images
  cleanup ${UNIQ}_legacy base
  # Remove all legacy images
  cleanup ${UNIQ}_legacy
  # Remove base images
  for DISTRO in $DISTROS; do
    cleanup ${UNIQ}_test_$DISTRO
  done
}

function cleanup {
  UUID=$1
  TAG=$2
  if [ -z "$TAG" ]; then
    IMAGES=$(docker images -q "${UUID}:*")
  else
    IMAGES=$(docker images -q "${UUID}:${TAG}")
  fi

  for IMAGE in $IMAGES; do
    docker image rm -f $IMAGE > /dev/null
  done
}

main
