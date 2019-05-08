NAME = kimai/kimai2
REPO_SOURCE="https://github.com/kevinpapst/kimai2.git"
TIMEOUT_MAX=10

# test: update-dev test-dev test-prod

test-dev:
	env NAME=$(NAME) REPO_SOURCE=$(REPO_SOURCE) TIMEOUT_MAX=$(TIMEOUT_MAX) bats --tap tests/dev.bats

test-prod:
	env NAME=$(NAME) REPO_SOURCE=$(REPO_SOURCE) TIMEOUT_MAX=$(TIMEOUT_MAX) bats --tap tests/prod.bats

build-base:
	docker build -t $(NAME)_base --rm base ${NO_CACHE}

build-dev:
	docker build -t $(NAME):dev --rm dev ${NO_CACHE}
	docker tag $(NAME):dev $(NAME):master ${NO_CACHE}

build-prod:
	docker build -t $(NAME):prod --rm prod

build: build-base build-dev build-prod test-dev test-prod

push:
	docker push $(NAME)_base
	docker push $(NAME):dev
	docker push $(NAME):master
	docker push $(NAME):latest
	docker push $(NAME):prod
