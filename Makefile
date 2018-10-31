NAME = kimai/kimai2
BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
VERSION = $(subst /,_,$(BRANCH))
SOURCE_REPO="https://github.com/tobybatch/kimai2.git"
TIMEOUT_MAX=5

test: update-dev
	env NAME=$(NAME) VERSION=$(VERSION) SOURCE_REPO=$(SOURCE_REPO) TIMEOUT_MAX=$(TIMEOUT_MAX) bats --tap tests/tests.bats

build: update-dev
	docker build -t $(NAME):$(VERSION) --rm dev

update-dev:
	# wget -O dev/Dockerfile https://raw.githubusercontent.com/kevinpapst/kimai2/master/Dockerfile
	wget -O dev/Dockerfile https://github.com/tobybatch/kimai2/raw/docker/Dockerfile

build-nocache:
	docker build -t $(NAME):$(VERSION) --rm --no-cache dev

tag-latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

push:
	docker push $(NAME):$(VERSION)

release: build test tag-latest push

info:
	@echo Branch is $(BRANCH)
	@echo Version is $(VERSION)
