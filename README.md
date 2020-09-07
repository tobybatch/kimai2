# Kimai Dockers

We provide a set of docker images for the [Kimai v2](https://github.com/kevinpapst/kimai2) project.

## Quick start

Run the latest master version of Kimai in production mode using a bundled sqlite DB:

    docker run --rm -ti -p 8001:8001 --name kimai2 kimai/kimai2

Create an admin user in the new running docker:

    docker exec kimai2 /opt/kimai/bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN

This docker transient and will disappear when you stop the container.

## Documentaion

 * [Starting a dev instance](docs/dev-instance.md#dev-instances)
 * [Using docker-compose](docs/docker-compose.md#docker-compose)
 * [All runtime arguments](docs/runtime-args.md#runtime-arguments)
 * [Building it yourself](docs/build.md#building-the-kimai-docker)
   * [Build arguments](docs/build.md#build-arguments)
 * [Troubleshooting](docs/troubleshooting.md#troubleshooting)
   * [NGINX and proxying](docs/troubleshooting.md#nginx-and-proxying)
   * [Fixing permissions](docs/troubleshooting.md#permissions)
   * [500 Server errors](docs/troubleshooting.md#500-server-errors)
   * [Older versions](docs/troubleshooting.md#older-version)
