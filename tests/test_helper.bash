setup() {
  IMAGE_NAME="$NAME:$VERSION"
  CONTAINER_NAME="kimai2_$(</dev/urandom tr -dc 'a-z0-9' | head -c8)"
  REPO_SOURCE="https://github.com/tobybatch/kimai2.git"
  REPO_DIR=$BATS_TEST_DIRNAME/$CONTAINER_NAME
  TIMEOUT_MAX=5
  BATS_LOG=$BATS_TEST_DIRNAME/bats.log
  log -e "\n================================="
  log "+ $BATS_TEST_NAME"
  log "---------------------------------"
}

teardown() {
    (docker stop $CONTAINER_NAME > /dev/null || true)
    log -e "Output\n------\n$output"
    docker run -v $REPO_DIR:/opt/kimai --rm ubuntu chown -R $(id -u):$(id -g) /opt/kimai
    rm -rf $REPO_DIR
}

build_image() {
    docker build --rm -t $1 $2 > /dev/null
}

run_image() {
    log docker run --rm -p 8001:8001 $@
    docker run --rm -p 8001:8001 $@
}

wait_for_image() {
    log -n "Waiting for $CONTAINER_NAME"
    CONTAINER_IP=$(docker inspect -f "{{ .NetworkSettings.IPAddress }}" $CONTAINER_NAME)
    TIMEOUT=0
    while [ "$HTTP_CODE" != 200 ]; do
        sleep 1
        log -n "."
        HTTP_CODE=$(curl -sL -w "%{http_code}\\n" "http://${CONTAINER_IP}:8001/" -o /dev/null)
        TIMEOUT=$((TIMEOUT+1))
        if (( TIMEOUT > ${TIMEOUT_MAX} )); then
            log -e "\nTimed out after $TIMEOUT seconds waiting for $CONTAINER_NAME to fully start"
            return 1
        fi
    done
    log -e "\n$CONTAINER_NAME served a 200 status front page"
}

execute_cmd() {
    log "Execute command: '$@'"
    docker exec -ti $CONTAINER_NAME $@
}

fetch_source_repo() {
    log git clone $REPO_SOURCE $1
    git clone $REPO_SOURCE $1
}

log() {
    echo $@ >> ${BATS_LOG}
}
