setup() {
  CONTAINER_NAME="bats_$(</dev/urandom tr -dc 'a-z0-9' | head -c8)"
  REPO_DIR=$BATS_TEST_DIRNAME/$CONTAINER_NAME
  BATS_LOG=$BATS_TEST_DIRNAME/bats.log
  log -e "\n================================="
  log "+ $BATS_TEST_NAME"
  log "---------------------------------"
}

teardown() {
    docker_list=$(docker ps -q)
    for docker in $docker_list; do
        name=$(docker inspect --format='{{.Name}}' $docker)
        trimmed=${name:1}
        if [[ "$trimmed" == bats_* ]]; then
            log "Stopping and removing $trimmed"
            docker stop $trimmed || true
            docker rm $trimmed || true
        fi
    done
    log -e "Output: $status\n------\n$output"
    docker run -v $REPO_DIR:/opt/kimai --rm ubuntu chown -R $(id -u):$(id -g) /opt/kimai
    # rm -rf $BATS_TEST_DIRNAME/bats_*
}

build_image() {
    docker build --rm -t $1 $2 2>&1 > /dev/null
}

run_image() {
    log docker run --rm -p 0:8001 $@
    docker run --rm -p 0:8001 $@
}

unit_tests() {
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/API && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Calendar && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Command && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Configuration && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Controller && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/DataFixtures && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Doctrine && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Entity && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Event && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/EventSubscriber && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Export && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Invoice && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Model && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Repository && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Security && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Timesheet && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Twig && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Utils && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Validator && \
  docker exec -t $1 /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Voter
}

execute_cmd() {
    log "Execute command: '$@'"
    docker exec -ti $CONTAINER_NAME $@
}

log() {
    echo $@ >> ${BATS_LOG}
}
