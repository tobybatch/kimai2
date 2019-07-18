# Kimai Dockers

[![Build Status](https://travis-ci.org/tobybatch/kimai2.svg?branch=master)](https://travis-ci.org/tobybatch/kimai2)

We provide a set of docker images for the [Kimai v2](https://github.com/kevinpapst/kimai2) project.

## Quick start

```bash
docker run --rm -ti -p 8001:8001 --name kimai2 kimai/kimai2:dev
docker exec kimai2 bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN admin
```

## Environment options

 * [Legacy Images](docs/legacy.md) (Kimai release tags <= 1.0.1)
 * Dev docker -  has no overridable env variables
 * [Master and images tagged at greater than 1.0.1](docs/runtime-config.md)

## Using docker-compose and NGINX

Example docker-compose files.

## Overriding default settings

You can alter settings by using [local.yaml](docs/runtime-config.md#local-overrides).  This will need to be mounted into the image.

    docker run -ti -p 8001:80001 -v $(pwd)/local.yaml:/opt/kimai/config/packages/local.yaml kimai/kimai2:master

## Images

### Legacy images

The tags 0.8 to 1.0.1 are all built to run in apache with either sqlite or mysql.  These images use a slightly structure to the later images.

### Base images

Post tag 1.0.1 different target stacks are included.  There is a bas eimage for each of the target stacks that include all the php pre-requisits for each stack.

### Dev image

The dev image is intended for testing or evaluation.  It is self conatained and runs against a sqlite DB.  It can be built with:

     docker build -t kimai/kimai2:dev --rm .

And started with an admin/admin super user:

    docker run --rm -ti -p 8001:8001 --name kimai2 kimai/kimai2:dev
    docker exec kimai2 bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN admin

### apache-debian

This image is built on debian and uses apache to serve the app.

### fpm-debian

This image is built on debian and uses FPM to server the site. It will require some sort of reverse proxy to handle the web requests.

### fpm-alpine

This image is built on alpine to provide a smaller image and uses FPM to server the site. It will require some sort of reverse proxy to handle the web requests.

