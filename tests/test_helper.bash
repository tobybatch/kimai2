setup() {
  BATS_LOG=$BATS_TEST_DIRNAME/bats.log
  log "+ $BATS_TEST_NAME"
}

teardown() {
  log -e "Output: $status\n------\n$output"
}

build_image() {
  log docker build --rm -t $1 $2 2>&1 > /dev/null
  docker build --rm -t $1 $2 2>&1 > /dev/null
}

run_image() {
  log docker run --rm -p 0:8001 --name kimai_test $1
  docker run -d --rm -p 0:8001 --name kimai_test $1
  wait_for_image kimai_test start
  docker stop kimai_test
  wait_for_image kimai_test stop
}

unit_tests() {
  docker run -d --rm -p 0:8001 --name kimai_test $1
  wait_for_image kimai_test start
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/API && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Calendar && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Command && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Configuration && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Controller && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/DataFixtures && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Doctrine && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Entity && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Event && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/EventSubscriber && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Export && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Invoice && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Model && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Repository && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Security && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Timesheet && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Twig && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Utils && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Validator && \
  docker exec -t kimai_test /opt/kimai/vendor/bin/phpunit /opt/kimai/tests/Voter
  docker stop kimai_test
  wait_for_image kimai_test stop
}

wait_for_image() {
  if [ "$2" == 'start' ]; then
    STATE=0
  elif [ "$2" == 'stop' ]; then
    STATE=1
  else
    exit -1
  fi
  echo "STATE $STATE"

  PORT=$(docker port $1 | cut -d ":" -f 2)
  STATUS=$?
  echo "port = $PORT"
  if [ -z "$PORT" ]; then
    # docker not running
    echo "docker not running"
    return 0;
  fi

  COUNT=0
  WAITING=1
  while [ "$WAITING" == 1 ]; do
    COUNT=$((COUNT + 1))
    if [ "$COUNT" -gt 10 ]; then
      WAITING=2
    fi
    nc -vz localhost $PORT
    STATUS=$?
    echo "nc status = $STATUS"
    if [ "$STATUS" == "$STATE" ]; then
      WAITING=0
      return;
    fi
    sleep 1
  done

  exit $WAITING
}

log() {
    echo -e $@ >> ${BATS_LOG}
}
