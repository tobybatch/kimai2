# Kimai Dockers

[![Build Status](https://travis-ci.org/tobybatch/kimai2.svg?branch=master)](https://travis-ci.org/tobybatch/kimai2)

We provide a set of docker images for the [Kimai v2](https://github.com/kevinpapst/kimai2) project.

## Quick start

### Evaluate

Run a throw away instamce of kimai for evauation ot testing,  This is built against the master branch of the kevinpapst/kimai2 project and runs against a sqlite database inside the container using the built in php server.  When stopped all trace of the docker will disapear.  If you run the lines below you can hit kimai at http://localhost:8001 and log in with admin / admin.  The test users listed in [the develop section](https://www.kimai.org/documentation/installation.html) also exist.

```bash
docker run --rm -ti -p 8001:8001 --name kimai2 kimai/kimai2:dev
docker exec kimai2 bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN admin
docker exec kimai2 bin/console kimai:reset-dev
```

### Production

Run a production kimai with persistent database in a seperate mysql conatiner. The best way of doing this is with a docker compose file. you can hit kimai at http://localhost:8001 and log in with superadmin / changeme123.

```yaml
version: '3'
services:

  mydb:
    image: mysql:5.6
    environment:
      - MYSQL_DATABASE=kimai
      - MYSQL_USER=kimaiu
      - MYSQL_PASSWORD=kimaip
      - MYSQL_ROOT_PASSWORD=changeme
    volumes:
        - ./mysql:/var/lib/mysql
    command: --default-storage-engine innodb
    restart: always

  kimai:
    image: kimai/kimai2:apache-debian-master
    environment:
        - APP_ENV=prod
        - DATABASE_URL=mysql://kimaiu:kimaip@mydb/kimai
        - ADMINMAIL=kimai@example.com
        - ADMINPASS=changeme123
    depends_on:
        - mydb
    ports:
        - 8001:8001
    restart: always

  postfix:
    image: catatnight/postfix
    environment:
      maildomain: neontribe.co.uk
      smtp_user: kimai:kimai
    restart: unless-stopped
    restart: always

```

## Permissions

If you are mounting the code base into the container (```-v $PWD/kimai:/opt/kimai```) then you will need to fix the permissions on the var folder.

    docker exec --user root CONTAINER_NAME chown -R www-data:www-data /opt/kimai/var

or

    docker-compose --user root exec CONTAINER_NAME chown -R www-data:www-data /opt/kimai/var

## Other options

- [Legacy images](docs/legacy.md) Versions of the docker <= 1.0.1 are no longer supported and uses outdated config.
- [Runtime config](docs/runtime-config.md) Setting such as DB conections and other secrets can be set using environment variables.
- [Local overides](docs/local-overrides.md) To change how Kimai, locale, durations settings etc a local overrides file can be used.
- [Docker compose files](docs/docker-compose.md) Different configs are provided to demonstrate different stacks and set ups.

## Dockerhub and images

More details on different images and how they are built is in the [dockerhub page](https://cloud.docker.com/u/kimai/repository/docker/kimai/kimai2)
