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

execute_cmd() {
    log "Execute command: '$@'"
    docker exec -ti $CONTAINER_NAME $@
}

fetch_source_repo() {
    log git clone $REPO_SOURCE $1
    git clone $REPO_SOURCE $1
}

run_composeup() {
    docker-compose -f $BATS_TEST_DIRNAME/../docker-compose.yml -p $1 up -d 2>&1 > /dev/null
}

log() {
    echo $@ >> ${BATS_LOG}
}
