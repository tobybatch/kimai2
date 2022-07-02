include .env

ifndef TIMEZONE
  TIMEZONE := Europe/London
endif

ifndef KIMAI_VERSION
  KIMAI_VERSION := master
endif

ifndef KIMAI_REPO
	KIMAI_REPO := https://github.com/kevinpapst/kimai2.git
endif

ifndef KIMAI_IMG
	KIMAI_IMG := kimai/kimai2
endif

ZAP := $(shell echo $(KIMAI_VERSION) | egrep -q "[0-9].[0-9]+" && echo matched)

.PHONY: buildx
buildx:
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--build-arg KIMAI=${KIMAI_VERSION} \
		--build-arg REPO=${KIMAI_REPO} \
		--build-arg BASE=fpm \
		--build-arg TZ=${TIMEZONE} \
		--target=dev \
		-t ${KIMAI_IMG}:fpm-dev \
		-t ${KIMAI_IMG}:latest-dev \
		.
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--build-arg KIMAI=${KIMAI_VERSION} \
		--build-arg REPO=${KIMAI_REPO} \
		--build-arg BASE=fpm \
		--build-arg TZ=${TIMEZONE} \
		--target=prod \
		-t ${KIMAI_IMG}:fpm-prod \
		-t ${KIMAI_IMG}:fpm \
		-t ${KIMAI_IMG}:latest \
		.
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--build-arg KIMAI=${KIMAI_VERSION} \
		--build-arg REPO=${KIMAI_REPO} \
		--build-arg BASE=apache \
		--build-arg TZ=${TIMEZONE} \
		--target=dev \
		-t ${KIMAI_IMG}:apache-dev \
		.
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--build-arg KIMAI=${KIMAI_VERSION} \
		--build-arg REPO=${KIMAI_REPO} \
		--build-arg BASE=apache \
		--build-arg TZ=${TIMEZONE} \
		--target=prod \
		-t ${KIMAI_IMG}:apache-prod \
		-t ${KIMAI_IMG}:apache \
		.

build:
	docker build -t ${KIMAI_IMG}:fpm-${KIMAI_VERSION}-dev --build-arg KIMAI=${KIMAI_VERSION} --build-arg BASE=fpm --build-arg TZ=${TIMEZONE} --target=dev .
	docker build -t ${KIMAI_IMG}:fpm-${KIMAI_VERSION}-prod --build-arg KIMAI=${KIMAI_VERSION} --build-arg BASE=fpm --build-arg TZ=${TIMEZONE} --target=prod .
	docker build -t ${KIMAI_IMG}:apache-${KIMAI_VERSION}-dev --build-arg KIMAI=${KIMAI_VERSION} --build-arg BASE=apache --build-arg TZ=${TIMEZONE} --target=dev .
	docker build -t ${KIMAI_IMG}:apache-${KIMAI_VERSION}-prod --build-arg KIMAI=${KIMAI_VERSION} --build-arg BASE=apache --build-arg TZ=${TIMEZONE} --target=prod .

tag:
ifeq (${ZAP}, matched)
	docker tag ${KIMAI_IMG}:fpm-${KIMAI_VERSION}-prod kimai/kimai2:fpm
	docker tag ${KIMAI_IMG}:fpm-${KIMAI_VERSION}-dev kimai/kimai2:fpm-dev
	docker tag ${KIMAI_IMG}:apache-${KIMAI_VERSION}-prod kimai/kimai2:apache
	docker tag ${KIMAI_IMG}:apache-${KIMAI_VERSION}-dev kimai/kimai2:apache-dev
	docker tag ${KIMAI_IMG}:fpm-${KIMAI_VERSION}-prod kimai/kimai2:latest
	docker tag ${KIMAI_IMG}:apache-${KIMAI_VERSION}-dev kimai/kimai2:latest-dev
else
	$(error ${KIMAI_VERSION} does not look like a release, x.y or x.y.z. Not tagging)
endif

push:
	docker push ${KIMAI_IMG}:fpm-${KIMAI_VERSION}-dev
	docker push ${KIMAI_IMG}:fpm-${KIMAI_VERSION}-prod
	docker push ${KIMAI_IMG}:apache-${KIMAI_VERSION}-dev
	docker push ${KIMAI_IMG}:apache-${KIMAI_VERSION}-prod
ifeq (${ZAP}, matched)
	docker push ${KIMAI_IMG}:fpm
	docker push ${KIMAI_IMG}:fpm-dev
	docker push ${KIMAI_IMG}:apache
	docker push ${KIMAI_IMG}:apache-dev
	docker push ${KIMAI_IMG}:latest
	docker push ${KIMAI_IMG}:latest-dev
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
	docker run --rm --network kimai-test --name kimai-test-fpm-${KIMAI_VERSION}-prod    -ti -e DATABASE_URL=mysql://kimai:kimai@kimai-mysql-testing:3306/kimai --entrypoint /self-test.sh kimai/kimai2:fpm-${KIMAI_VERSION}-prod
	docker run --rm --network kimai-test --name kimai-test-fpm-${KIMAI_VERSION}-dev     -ti -e DATABASE_URL=mysql://kimai:kimai@kimai-mysql-testing:3306/kimai --entrypoint /self-test.sh kimai/kimai2:fpm-${KIMAI_VERSION}-dev
	docker run --rm --network kimai-test --name kimai-test-apache-${KIMAI_VERSION}-prod -ti -e DATABASE_URL=mysql://kimai:kimai@kimai-mysql-testing:3306/kimai --entrypoint /self-test.sh kimai/kimai2:apache-${KIMAI_VERSION}-prod
	docker run --rm --network kimai-test --name kimai-test-apache-${KIMAI_VERSION}-dev  -ti -e DATABASE_URL=mysql://kimai:kimai@kimai-mysql-testing:3306/kimai --entrypoint /self-test.sh kimai/kimai2:apache-${KIMAI_VERSION}-dev

changelog_patch:
	# npx standard-version --release-as 1.1.0
	npx standard-version --release-as patch

changelog_minor:
	npx standard-version --release-as minor

changelog_major:
	npx standard-version --release-as major

build-version: build test push

release: build test tag push
