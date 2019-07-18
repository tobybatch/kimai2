build_image() {
  if [ "NA" == "$2" [; then
    echo "docker build --rm -t $1 $3" >> /tmp/build.log
  else
    echo "docker build --rm -t $1 --build-arg TAG=$2 $3" >> /tmp/build.log
  fi
  docker build --rm -t $1 --build-arg TAG=$2 $3
}

unit_tests() {
  echo "docker run -d --rm -p 0:8001 --name kimai_test $1" >> /tmp/build.log
  docker run -d --rm -p 0:8001 --name kimai_test $1
  while [ 1 != "$RUNNING" ]; do
    sleep 1
    docker exec kimai_test /bin/cat /etc/hosts > /dev/null
    if [ "$?" ]; then
      RUNNING=1
    fi
  done
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
}
