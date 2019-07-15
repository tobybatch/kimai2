#!/usr/bin/env 
  
load test_helper

@test "build image" {
  run build_image $NAME $TAG $DOCKER_DIR
  [ "$status" -eq 0 ]
}
