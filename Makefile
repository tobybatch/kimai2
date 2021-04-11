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

# Inherited from the environment
# DOCKER_BUILDKIT

build:
	$(foreach stage,${STAGES}, $(foreach base,${BASES}, \
		$(info Building kimai2/kimai:${base}-${KIMAI_VERSION}-${stage}) \
		$(shell \
        		docker build -t kimai2/kimai:$(base)-${KIMAI_VERSION}-$(stage) \
        		--build-arg KIMAI=${KIMAI_VERSION} \
        		--build-arg BASE=${base} \
        		--build-arg TZ=${TIMEZONE} \
        		--target=${stage}\
        		. \
        	) \
	)))

test:

release:
