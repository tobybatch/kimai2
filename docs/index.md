# Kimai Dockers

We provide a set of docker images for the [Kimai v2](https://github.com/kevinpapst/kimai2) project.

The built images are available from [Kimai v2](https://hub.docker.com/r/kimai/kimai2) at Docker Hub.

## Quick start

Run the latest production build:

1. Start a DB

    ```bash
        docker run --rm --name kimai-mysql-testing \
            -e MYSQL_DATABASE=kimai \
            -e MYSQL_USER=kimai \
            -e MYSQL_PASSWORD=kimai \
            -e MYSQL_ROOT_PASSWORD=kimai \
            -p 3399:3306 -d mysql
    ```

2. Start Kimai

    ```bash
        docker run --rm --name kimai-test \
            -ti \
            -p 8001:8001 \
            -e DATABASE_URL=mysql://kimai:kimai@${HOSTNAME}:3399/kimai \
            kimai/kimai2:apache
    ```

3. Add a user using the terminal

    ```bash
        docker exec -ti kimai-test \
            /opt/kimai/bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN
    ```

Now, you can access the Kimai instance at <http://localhost:8001>.

__Note:__
If you're using Docker for Windows or Docker for Mac, and you're getting "Connection refused" or other errors, you might need to change `${HOSTNAME}` to `host.docker.internal`.
This is because the Kimai Docker container can only communicate within its network boundaries. Alternatively, you can start the container with the flag `--network="host"`.
See [here](https://stackoverflow.com/questions/24319662/from-inside-of-a-docker-container-how-do-i-connect-to-the-localhost-of-the-mach) for more information.

Keep in mind that this Docker setup is transient and the data will disappear when you remove the containers.

```bash
    docker stop kimai-mysql-testing kimai-test
    docker rm kimai-mysql-testing kimai-test
```

## Using docker-compose

This will run the latest prod version using FPM with an nginx reverse proxy

See the [[docker-compose.yml](https://github.com/tobybatch/kimai2/blob/main/docker-compose.yml)] in the root of this repo.

## Documentation

[https://tobybatch.github.io/kimai2/](https://tobybatch.github.io/kimai2/)

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
