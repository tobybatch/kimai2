# Kimai Dockers

We provide a set of docker images for the [Kimai v2](https://github.com/kevinpapst/kimai2) project.

## Quick start

Run the latest production build:

 1. Start a DB

        docker run --rm --name kimai-mysql-testing -e MYSQL_DATABASE=kimai -e MYSQL_USER=kimai -e MYSQL_PASSWORD=kimai -e MYSQL_ROOT_PASSWORD=kimai -p 3399:3306 -d mysql

 1. Start Kimai

        docker run --rm --name kimai-test -ti -p 8001:8001 -e DATABASE_URL=mysql://kimai:kimai@${HOSTNAME}:3399/kimai kimai/kimai2:apache

 1. Add a user, open a new terminal and:

        docker exec -ti kimai-test /bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN

You can now hit the kimai instance on <http://localhost:8001>

This docker transient and will disappear when you stop the containers.

    docker stop kimai-mysql-testing kimai-test

## Documentation

* [Updating the image](updating.md)
* [All runtime arguments](runtime-args.md#runtime-arguments)
* [Building it yourself](build.md#building-the-kimai-docker)
  * [Build arguments](build.md#build-arguments)
  * [Extending the image](build.md#extending-the-image)
* [Helm and Kubernetes](helm.md)
* [Troubleshooting](troubleshooting.md#troubleshooting)
  * [NGINX and proxying](troubleshooting.md#nginx-and-proxying)
  * [Fixing permissions](troubleshooting.md#permissions)
  * [500 Server errors](troubleshooting.md#500-server-errors)
  * [Older versions](troubleshooting.md#older-version)
* [Examples](examples.md)
  * [docker-compose](examples.md#docker-compose)
    * [apache dev instance](examples.md#apache-dev)
    * [fpm prod instance](examples.md#fpm-prod)

## Helping out

If you find a bug or have a feature request then create a tickets [here](https://github.com/tobybatch/kimai2/issues). We'd like to upgrade the dockerhub account to a rate free account and if you'd like to help with that then please donate via [paypal](https://www.paypal.com/paypalme/tobybatchuk).
