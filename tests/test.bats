#!/usr/bin/env 
  
load test_helper
@test "build image" {
  run build_image $NAME $DOCKER_DIR
  [ "$status" -eq 0 ]
}

@test "run image" {
  run run_image $NAME
  [ "$status" -eq 0 ]
}

@test "run unit tests" {
  run unit_tests
  [ "$status" -eq 0 ]
}

