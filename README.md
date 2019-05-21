## Kimai Dockers

[![Build Status](https://travis-ci.org/tobybatch/kimai2.svg?branch=master)](https://travis-ci.org/tobybatch/kimai2)

## Dockerhub

Docker hub hosts a number of tagged releases, starting with 0.8.  These are all build against a production docker file that will function best with an external MYSQL DB.

In addition there a dev image that is built for development / quick test purposes. 

## Development docker

### Building

```bash
 docker build -t kimai/kimai2:dev --rm .
```

### Starting the docker (sqlite)

```bash
docker run --rm -ti -p 8001:8001 --name kimai2 kimai/kimai2:dev
docker exec kimai2 bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN admin
```

## Production docker

### Building

Each of the folders in the tag folder hold a build for a different tag.  You can build any tag by passing it to the docker build command. e.g.

```bash
 docker build -t kimai/kimai2:prod --build-arg "TAG=0.9" --rm tags/0.9
```

Use the latest tag for the most stable conatiner, the passed TAG arg will override the version of kimai built.

### Starting the docker (sqlite)

```bash
docker run --rm -ti -p 8001:8001 --name kimai2 kimai/kimai2:0.9
docker exec kimai2 bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN admin
```

### Starting the docker (mysql)

The prod image will require an external mysql db to store the kimai data.  Pass one via the DATABASE_URL runtime argument. e.g.

```bash
docker run -ti -p 8001:8001 --name kimai2 \
    -e DATABASE_URL=mysql://kimai_user:kimai_pass@somehost/kimai_db \
    kimai/kimai2:0.9
```

### Docker compose

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
        - mysql:/var/lib/mysql
    command: --default-storage-engine innodb
    restart: always

  kimai:
    image: kimai/kimai2:0.9
    environment:
        - APP_ENV=prod
        # These are added to override the the DB URL from env when checking the DB status during start up.
        - DATABASE_URL=mysql://kimaiu:kimaip@mydb/kimai
    depends_on:
        - mydb
    ports:
        - 8001:8001
    restart: always

volumes:
  mysql
```

### Runtime args

**Database Passwords**

Database configurations are set using a url schema.  If you use a password that contains character like /, \ or @ Kimai will not work as it can't parse the URL.  I will add protection for this but not in the near future.  I am very happy to accept a patch that will do that for me.

You can override settings at run time, e.g.:

    docker run --rm -ti \
        -p 8001:8001 \
        --name kimai2 \
        -e MAILER_FROM=me@example.com \
        -e APP_ENV=dev \
        -e APP_SECRET=shhh_no_one_will_guess_this \
        -e TRUSTED_PROXIES=192.0.0.1 \
        -e TRUSTED_HOSTS=localhost \
        -e DATABASE_URL=mysql://kimaiu:kimaip@mydb/kimai \ # | DATABASE_URL=sqlite:///%kernel.project_dir%/var/data/kimai.sqlite
        -e MAILER_URL=smtp://user:pass@host:port/?timeout=60&encryption=ssl&auth_mode=login \
        kimai/kimai2:0.9

#### Create admin user:

    docker-compose exec kimai bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN admin

#### Kimai default env vars:

see [https://github.com/kevinpapst/kimai2].

 * MAILER_FROM
   Default: ```kimai@example.com```
   The from address for mails from the system.

#### Symfony framework bundle

see [https://symfony.com/doc/current/reference/configuration/framework.html].

 * APP_ENV
   Default: ```prod```
 * APP_SECRET
   Default: ```change_this_to_something_unique```
 * TRUSTED_PROXIES
   Default: Not set by default
 * TRUSTED_HOSTS
   Default: Not set by default

#### Doctrine bundle

see [https://symfony.com/doc/current/reference/configuration/doctrine.html].

The old DATABASE_URL is back!

Default: ```sqlite:///%kernel.project_dir%/var/data/kimai.sqlite```

or it can be customised: ```mysql://kimaiu:kimaip@mydb/kimai```

#### Swiftmailer bundle

see [https://symfony.com/doc/current/reference/configuration/swiftmailer.html]

 * MAILER_URL
   Default: ```null://localhost```

### Create a user

    docker exec -ti kimai2 bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN admin

