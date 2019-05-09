#!/bin/bash

function test_image {
  env NAME=$1 DOCKER_DIR=$2 bats --tap tests/test.bats
}

test_image kimai/kimai2_base:test base

for x in $(ls tags); do
  test_image kimai/kimai2:${x}_test tags/$x
done

test_image kimai/kimai2:dev_test .

