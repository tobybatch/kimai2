# Kimai Dockers

We provide a set of docker images for the [Kimai v2](https://github.com/kevinpapst/kimai2) project.

## Upgrading

The newer kimai instances cache images in the var directory (/opt/kimai/var).
This folder will need to be preserved and mounted into newer builds.
The docker compose file below will handle that but if you didn't save those file you will need to do that manually.

## Quick start

### Evaluate

Run a throw away instance of kimai for evaluation or testing.
This is built against the master branch of the kevinpapst/kimai2 project and runs against a sqlite database inside the container using the built in php server.
When stopped all trace of the docker will disappear.
If you run the lines below you can hit kimai at `http://localhost:8001` and log in with `admin` / `changemeplease`
The test users listed in [the develop section](https://www.kimai.org/documentation/installation.html) also exist.

```bash
docker run --rm -ti -p 8001:8001 --name kimai2 kimai/kimai2:apache-debian-1.8-dev
docker exec kimai2 rm /opt/kimai/var/data/kimai.sqlite
docker exec kimai2 /opt/kimai/bin/console kimai:reset-dev
docker exec kimai2 /opt/kimai/bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN changemeplease
```

### Production

Run a production kimai with persistent database in a seperate mysql container.
The best way of doing this is with a docker compose file.
You can hit kimai at `http://localhost:8001` and log in with `superadmin` / `changemeplease`.

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
      - ./nginx_site.conf:/etc/nginx/conf.d/default.conf:ro
      - public:/opt/kimai/public:ro
    restart: unless-stopped
    depends_on:
      - kimai
    healthcheck:
      test:  wget --spider http://nginx/health || exit 1
      interval: 20s
      start_period: 10s
      timeout: 10s
      retries: 3

  kimai:
    image: kimai/kimai2:fpm-alpine-1.8-prod
    environment:
      - APP_ENV=prod
      - TRUSTED_HOSTS=localhost
      - ADMINMAIL=admin@kimai.local
      - ADMINPASS=changemeplease
    volumes:
      - public:/opt/kimai/public
      - var:/opt/kimai/var
      # - ./ldap.conf:/etc/openldap/ldap.conf:z
      # - ./ROOT-CA.pem:/etc/ssl/certs/ROOT-CA.pem:z
    restart: unless-stopped
    healthcheck:
      test: wget --spider http://nginx || exit 1
      interval: 20s
      start_period: 10s
      timeout: 10s
      retries: 3

  postfix:
    image: catatnight/postfix:latest
    environment:
      maildomain: kimai.local
      smtp_user: kimai:kimai
    restart: unless-stopped

volumes:
    var:
    public:
```

## Permissions

If you are mounting the code base into the container (`-v $PWD/kimai:/opt/kimai`) then you will need to fix the permissions on the var folder.

```bash
docker exec --user root CONTAINER_NAME chown -R www-data:www-data /opt/kimai/var
```

or

```bash
docker-compose --user root exec CONTAINER_NAME chown -R www-data:www-data /opt/kimai/var
```

## Runtime Arguments

The following settings can set at runtime:

Kimai/symfony core settings, see the symfony and kimai docs for more info on these.

```bash
DATABASE_URL=sqlite:///%kernel.project_dir%/var/data/kimai.sqlite
APP_SECRET=change_this_to_something_unique
TRUSTED_PROXIES=nginx,localhost,127.0.0.1
TRUSTED_HOSTS=nginx,localhost,127.0.0.1
MAILER_FROM=kimai@example.com
MAILER_URL=null://localhost
```

Start up values:

If set then these values will try and create a new admin user.

```bash
ADMINPASS=
ADMINMAIL=
```

## NGINX and proxying

While outside the direct responsibility of this project we get a lot of issues reported that relate to proxying with NGINX into the FPM container.
Note that you will need to set the name of your NGINX container to be in the list of TRUSTED_HOSTS when you start the kimai container.
