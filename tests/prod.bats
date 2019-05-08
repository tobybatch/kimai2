#!/usr/bin/env bats
  
load test_helper

@test "image build dev" {
  run build_image $NAME:prod $BATS_TEST_DIRNAME/../prod
  [ "$status" -eq 0 ]
}

@test "image start dev" {
  run run_image --name $CONTAINER_NAME -d $NAME:prod
  [ "$status" -eq 0 ]
}

@test "run unit tests" {
  run run_image --name $CONTAINER_NAME -d $NAME:prod
  [ "$status" -eq 0 ]
  run unit_tests $CONTAINER_NAME
  [ "$status" -eq 0 ]
}



# Prod docker stand alone

# Prod docker DATABASE_PREFIX

# Prod docker MAILER_FROM


# Prod docker APP_ENV

# Prod docker APP_SECRET

# Prod docker TRUSTED_HOSTS

# Prod docker TRUSTED_PROXIES


# Prod docker DATABASE_URL


# Prod docker MAILER_URL

