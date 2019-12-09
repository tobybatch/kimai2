# Kimai Dockers

[![Build Status](https://travis-ci.org/tobybatch/kimai2.svg?branch=master)](https://travis-ci.org/tobybatch/kimai2)

We provide a set of docker images for the [Kimai v2](https://github.com/kevinpapst/kimai2) project.

## Updgrading

The newer kimai instances cache images in the var directory (/opt/kimai/var).  This folder will need to be preserved and mounted into newer builds.  The docker compose file below will handle that but if you didn't save those file you will need to do that manually.

## Quick start

### Evaluate

Run a throw away instamce of kimai for evauation ot testing,  This is built against the master branch of the kevinpapst/kimai2 project and runs against a sqlite database inside the container using the built in php server.  When stopped all trace of the docker will disapear.  If you run the lines below you can hit kimai at http://localhost:8001 and log in with admin / admin.  The test users listed in [the develop section](https://www.kimai.org/documentation/installation.html) also exist.

```bash
docker run --rm -ti -p 8001:8001 --name kimai2 kimai/kimai2:apache-debian-master-prod
docker exec kimai2 bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN admin
docker exec kimai2 bin/console kimai:reset-dev
```

### Production

Run a production kimai with persistent database in a seperate mysql conatiner. The best way of doing this is with a docker compose file. you can hit kimai at http://localhost:8001 and log in with superadmin / changeme123.

```yaml
version: '3.5'
services:

  sqldb:
    image: mysql:5.7
    environment:
      - MYSQL_DATABASE=kimai
      - MYSQL_USER=kimaiuser
      - MYSQL_PASSWORD=kimaipassword
      - MYSQL_ROOT_PASSWORD=changemeplease
    volumes:
      - /var/lib/mysql
    command: --default-storage-engine innodb
    restart: unless-stopped
    healthcheck:
      test: mysqladmin -pchangemeplease ping -h localhost
      interval: 20s
      start_period: 10s
      timeout: 10s
      retries: 3 

  nginx:
    build: compose
    ports:
      - 8001:80
    volumes:
      - ./nginx_site.conf:/etc/nginx/conf.d/default.conf
    restart: unless-stopped
    depends_on:
      - kimai
    volumes:
      - public:/opt/kimai/public
    healthcheck:
      test:  wget --spider http://nginx/health || exit 1 
      interval: 20s
      start_period: 10s
      timeout: 10s
      retries: 3 

  kimai:
    image: kimai/kimai2:fpm-alpine-1.5-prod
    environment:
      - APP_ENV=prod
      - TRUSTED_HOSTS=localhost
      - ADMINMAIL=admin@kimai.local
      - ADMINPASS=changemeplease
    volumes:
      - public:/opt/kimai/public
      - var:/opt/kimai/var
    restart: unless-stopped
    healthcheck:
      test: wget --spider http://nginx || exit 1
      interval: 20s
      start_period: 10s
      timeout: 10s
      retries: 3

  postfix:
    image: catatnight/postfix
    environment:
      maildomain: neontribe.co.uk
      smtp_user: kimai:kimai
    restart: unless-stopped
    restart: always

volumes:
    var:
    public:

```

## Permissions

If you are mounting the code base into the container (```-v $PWD/kimai:/opt/kimai```) then you will need to fix the permissions on the var folder.

    docker exec --user root CONTAINER_NAME chown -R www-data:www-data /opt/kimai/var

or

    docker-compose --user root exec CONTAINER_NAME chown -R www-data:www-data /opt/kimai/var


