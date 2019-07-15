#!/usr/bin/env 
  
load test_helper

# run unit tests
@test "test image" {
  run unit_tests $NAME:$TAG
  [ "$status" -eq 0 ]
}
