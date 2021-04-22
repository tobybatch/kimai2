include .env

ifndef TIMEZONE
  TIMEZONE := Europe/London
endif

ifndef KIMAI_VERSION
  KIMAI_VERSION := master
endif

ZAP := $(shell echo $(KIMAI_VERSION) | egrep -q "[0-9].[0-9]+" && echo matched)

build:
	docker build -t kimai2/kimai:fpm-${KIMAI_VERSION}-dev --build-arg KIMAI=${KIMAI_VERSION} --build-arg BASE=fpm --build-arg TZ=${TIMEZONE} --target=dev .
	docker build -t kimai2/kimai:fpm-${KIMAI_VERSION}-prod --build-arg KIMAI=${KIMAI_VERSION} --build-arg BASE=fpm --build-arg TZ=${TIMEZONE} --target=prod .
	docker build -t kimai2/kimai:apache-${KIMAI_VERSION}-dev --build-arg KIMAI=${KIMAI_VERSION} --build-arg BASE=apache --build-arg TZ=${TIMEZONE} --target=dev .
	docker build -t kimai2/kimai:apache-${KIMAI_VERSION}-prod --build-arg KIMAI=${KIMAI_VERSION} --build-arg BASE=apache --build-arg TZ=${TIMEZONE} --target=prod .

tag:
ifeq (${ZAP}, matched)
	docker tag kimai2/kimai:fpm-${KIMAI_VERSION}-prod kimai2/kimai:fpm-latest-prod
	docker tag kimai2/kimai:fpm-${KIMAI_VERSION}-dev kimai2/kimai:fpm-latest-dev
	docker tag kimai2/kimai:apache-${KIMAI_VERSION}-prod kimai2/kimai:apache-latest-prod
	docker tag kimai2/kimai:apache-${KIMAI_VERSION}-dev kimai2/kimai:apache-latest-dev
	docker tag kimai2/kimai:fpm-${KIMAI_VERSION}-prod kimai2/kimai:latest
	docker tag kimai2/kimai:apache-${KIMAI_VERSION}-dev kimai2/kimai:latest-dev
else
	$(error ${KIMAI_VERSION} does not look like a release, x.y or x.y.z. Not tagging)
endif

push:
	docker push kimai2/kimai:fpm-${KIMAI_VERSION}-dev
	docker push kimai2/kimai:fpm-${KIMAI_VERSION}-prod
	docker push kimai2/kimai:apache-${KIMAI_VERSION}-dev
	docker push kimai2/kimai:apache-${KIMAI_VERSION}-prod
ifeq (${ZAP}, matched)
	docker push kimai2/kimai:kimai2/kimai:fpm-latest-prod
	docker push kimai2/kimai:kimai2/kimai:fpm-latest-dev
	docker push kimai2/kimai:kimai2/kimai:apache-latest-prod
	docker push kimai2/kimai:kimai2/kimai:apache-latest-dev
	docker push kimai2/kimai:kimai2/kimai:latest
	docker push kimai2/kimai:kimai2/kimai:latest-dev
endif

clean-test:
	docker stop kimai-mysql-testing || true
	docker stop kimai-test-fpm-${KIMAI_VERSION}-prod || true
	docker stop kimai-test-fpm-${KIMAI_VERSION}-dev || true
	docker stop kimai-test-apache-${KIMAI_VERSION}-prod || true
	docker stop kimai-test-apache-${KIMAI_VERSION}-dev || true
	docker network rm kimai-test || true

test: clean-test
	docker network create --driver bridge kimai-test
	docker run --rm --network kimai-test --name kimai-mysql-testing -e MYSQL_DATABASE=kimai -e MYSQL_USER=kimai -e MYSQL_PASSWORD=kimai -e MYSQL_ROOT_PASSWORD=kimai -p 3399:3306 -d mysql
	docker run --rm --network kimai-test --name kimai-test-fpm-${KIMAI_VERSION}-prod    -ti -e DATABASE_URL=mysql://kimai:kimai@kimai-mysql-testing:3306/kimai --entrypoint /self-test.sh kimai2/kimai:fpm-${KIMAI_VERSION}-prod
	docker run --rm --network kimai-test --name kimai-test-fpm-${KIMAI_VERSION}-dev     -ti -e DATABASE_URL=mysql://kimai:kimai@kimai-mysql-testing:3306/kimai --entrypoint /self-test.sh kimai2/kimai:fpm-${KIMAI_VERSION}-dev
	docker run --rm --network kimai-test --name kimai-test-apache-${KIMAI_VERSION}-prod -ti -e DATABASE_URL=mysql://kimai:kimai@kimai-mysql-testing:3306/kimai --entrypoint /self-test.sh kimai2/kimai:apache-${KIMAI_VERSION}-prod
	docker run --rm --network kimai-test --name kimai-test-apache-${KIMAI_VERSION}-dev  -ti -e DATABASE_URL=mysql://kimai:kimai@kimai-mysql-testing:3306/kimai --entrypoint /self-test.sh kimai2/kimai:apache-${KIMAI_VERSION}-dev

build-version: build test push

release: build test tag push