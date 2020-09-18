# Kimai Dockers

We provide a set of docker images for the [Kimai v2](https://github.com/kevinpapst/kimai2) project.

## Quick start

Run the latest dev version of Kimai in production mode using a bundled DB. **This is not suitable for production use**:

    docker run --rm -ti -p 8001:8001 --name kimai kimai/kimai2:latest-dev

Create an admin user in the new running docker:

    docker exec kimai /opt/kimai/bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN

This docker transient and will disappear when you stop the container.

## Documentation

* [Starting a dev instance](dev-instance.md#dev-instances)
* [Using docker-compose](docker-compose.md#docker-compose)
* [All runtime arguments](runtime-args.md#runtime-arguments)
* [Building it yourself](build.md#building-the-kimai-docker)
  * [Build arguments](build.md#build-arguments)
* [Troubleshooting](troubleshooting.md#troubleshooting)
  * [NGINX and proxying](troubleshooting.md#nginx-and-proxying)
  * [Fixing permissions](troubleshooting.md#permissions)
  * [500 Server errors](troubleshooting.md#500-server-errors)
  * [Older versions](troubleshooting.md#older-version)
