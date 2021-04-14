include .env

ifndef BASES
  BASES := fpm apache
endif

ifndef TIMEZONE
  TIMEZONE := Europe/London
endif

ifndef STAGES
  STAGES := dev prod
endif

ifndef KIMAI_VERSION
  KIMAI_VERSION := master
endif

# https://itnext.io/docker-makefile-x-ops-sharing-infra-as-code-parts-ea6fa0d22946
# https://gist.github.com/mpneuried/0594963ad38e68917ef189b4e6a269db

# Inherited from the environment
# DOCKER_BUILDKIT

build:
	$(foreach stage,${STAGES}, $(foreach base,${BASES}, \
		$(info Building kimai2/kimai:${base}-${KIMAI_VERSION}-${stage}) \
		docker build -t kimai2/kimai:$(base)-${KIMAI_VERSION}-$(stage) --build-arg KIMAI=${KIMAI_VERSION} --build-arg BASE=${base} --build-arg TZ=${TIMEZONE} --target=${stage} .; \
	))

test:

tag:

push:

release: build test tag push
