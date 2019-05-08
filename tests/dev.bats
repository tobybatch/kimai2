#!/usr/bin/env bats
  
load test_helper

@test "image build dev" {
  run build_image $NAME:dev $BATS_TEST_DIRNAME/../dev
  [ "$status" -eq 0 ]
}

@test "image start dev" {
  run run_image --name $CONTAINER_NAME -d $NAME:dev
  [ "$status" -eq 0 ]
}

@test "run unit tests" {
  run run_image --name $CONTAINER_NAME -d $NAME:dev
  [ "$status" -eq 0 ]
  run unit_tests $CONTAINER_NAME
  [ "$status" -eq 0 ]
}

