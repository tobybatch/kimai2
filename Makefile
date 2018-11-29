NAME = kimai/kimai2
REPO_SOURCE="https://github.com/kevinpapst/kimai2.git"
TIMEOUT_MAX=10

test: update-dev test-dev test-prod

test-dev:
	env NAME=$(NAME) REPO_SOURCE=$(REPO_SOURCE) TIMEOUT_MAX=$(TIMEOUT_MAX) bats --tap tests/dev.bats

test-prod:
	env NAME=$(NAME) REPO_SOURCE=$(REPO_SOURCE) TIMEOUT_MAX=$(TIMEOUT_MAX) bats --tap tests/prod.bats

build: update-dev
	docker build -t $(NAME):dev --rm dev
	docker build -t $(NAME):prod --rm prod

update-dev:
	wget -O dev/Dockerfile https://raw.githubusercontent.com/kevinpapst/kimai2/master/Dockerfile
	# wget -O dev/Dockerfile https://github.com/tobybatch/kimai2/raw/docker/Dockerfile

build-nocache:
	docker build -t $(NAME):dev --rm --no-cache dev
	docker build -t $(NAME):prod --rm --no-cache prod

tag-latest:
	docker tag $(NAME):dev $(NAME):latest

push:
	docker push $(NAME):dev
	docker push $(NAME):latest
	docker push $(NAME):prod

release: build test tag-latest push
