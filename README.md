# kimai-docker

Docker containers for the kimai2 web application

## Dev docker

The docker file for development is bundled in the Kimai project: https://github.com/kevinpapst/kimai2

## Production docker

    docker run --rm -ti -p 8080:8080 --name kimai2 kimai/kimai2

More options: [prod](prod/README.md)

## Tests

We use bats for testing:

    make test
