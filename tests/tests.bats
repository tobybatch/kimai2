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

@test "check dev site up" {
    run run_image --name $CONTAINER_NAME -d ${NAME}:dev
    run wait_for_image
    [ "$status" -eq 0 ]
}

@test "full local dev version" {
    run fetch_source_repo $REPO_DIR
    [ "$status" -eq 0 ]
    run run_image -v $BATS_TEST_DIRNAME:/bats_dir -ti ubuntu chown -R 33:33 /bats_dir/kimai2_*
    [ "$status" -eq 0 ]
    run run_image -v $REPO_DIR:/opt/kimai -ti ${NAME}:dev composer install --dev --optimize-autoloader
    [ "$status" -eq 0 ]
    run run_image -v $REPO_DIR:/opt/kimai -ti ${NAME}:dev /opt/kimai/bin/console -n doctrine:database:create
    [ "$status" -eq 0 ]
    run run_image -v $REPO_DIR:/opt/kimai -ti ${NAME}:dev /opt/kimai/bin/console -n doctrine:schema:create
    [ "$status" -eq 0 ]
    run run_image -v $REPO_DIR:/opt/kimai -ti ${NAME}:dev /opt/kimai/bin/console -n doctrine:migrations:version --add --all
    [ "$status" -eq 0 ]
    run run_image -v $REPO_DIR:/opt/kimai -ti ${NAME}:dev /opt/kimai/bin/console cache:warmup
    [ "$status" -eq 0 ]
    run run_image -v $REPO_DIR:/opt/kimai -ti ${NAME}:dev 'sed "s/prod/dev/g" /opt/kimai/.env.dist > /opt/kimai/.env'
    [ "$status" -eq 0 ]
    run run_image -v $REPO_DIR:/opt/kimai --name $CONTAINER_NAME $NAME:dev
    [ "$status" -eq 0 ]
    run wait_for_image
    [ "$status" -eq 0 ]
    run run_image -v $REPO_DIR:/opt/kimai -ti --user root ${NAME}:dev chown -R $(id -u):$(id -g) .
    [ "$status" -eq 0 ]
}

@test "existing db and local source tree" {
    run fetch_source_repo $REPO_DIR
    [ "$status" -eq 0 ]
    run run_image -v $REPO_DIR/src:/opt/kimai/src -v $BATS_TEST_DIRNAME/test.sqlite:/opt/kimai/var/data/kimai.sqlite -d --name $CONTAINER_NAME ${NAME}:dev
    [ "$status" -eq 0 ]
    docker run -v $BATS_TEST_DIRNAME/test.sqlite:/kimai.sqlite --rm ubuntu chown 33:33 /kimai.sqlite
    [ "$status" -eq 0 ]
    run execute_cmd bin/console fos:user:promote tobias ROLE_ADMIN
    [ "$status" -eq 0 ]
    run wait_for_image
    [ "$status" -eq 0 ]
}
