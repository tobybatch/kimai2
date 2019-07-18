# Docker compose

Here are some example docker compose files.

## Simple legacy docker with mysql DB

All files [here](https://github.com/tobybatch/kimai2/tree/master/docker-compose/legacy)

```bash
docker compose up -d
docker-compose exec kimai bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN admin
```

```yaml
version: '3'
services:

  mysql:
    image: mysql:5.7
    environment:
      - MYSQL_DATABASE=kimai
      - MYSQL_USER=kimai
      - MYSQL_PASSWORD=kimai
      - MYSQL_ROOT_PASSWORD=changeme
    volumes:
        - ./mysql:/var/lib/mysql
    command: --default-storage-engine innodb --secure-file-priv=/var/tmp/
    restart: always

  kimai:
    image: kimai/kimai2:1.0
    environment:
      - APP_ENV=prod
      - APP_SECRET=some-thing-really-secret
      - DATABASE_URL=mysql://kimai:kimai@mysql/kimai
      - MAILER_FROM=kimai@neontribe.co.uk
      - MAILER_URL="smtp://kimai:kimai@postfix:25/?timeout=60"
    depends_on:
        - mysql
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

## Apache/debian docker with mysql db

All files [here](https://github.com/tobybatch/kimai2/tree/master/docker-compose/apache-debian)

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
        - ADMINPASS=pass123
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

## NGINX/FPM/debian docker with mysql db

All files [here](https://github.com/tobybatch/kimai2/tree/master/docker-compose/nginx)

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

  nginx:
    image: nginx:latest
    ports:
        - 8001:80
    volumes:
      - ./codebase:/opt/shared_kimai
      - ./nginx_site.conf:/etc/nginx/conf.d/default.conf

  kimai_fpm:
    image: kimai/kimai2:fpm-alpine-master
    environment:
        - APP_ENV=dev
        - TRUSTED_HOSTS=localhost
        - DATABASE_URL=mysql://kimaiu:kimaip@mydb/kimai
        - ADMINMAIL=kimai@example.com
        - ADMINPASS=pass123
    volumes:
      - ./codebase:/opt/shared_kimai
    entrypoint: /nginx-startup.sh
```

## Apache/debian docker with mysql db in a different locale

All files [here](https://github.com/tobybatch/kimai2/tree/master/docker-compose/apache-debian-uk)

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
        - ADMINPASS=pass123
    volumes:
        - ./local.yaml:/opt/kimai/config/packages/local.yaml
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

## Apache/debian docker with mysql db in a different locale and LDAP auth

All files [here](https://github.com/tobybatch/kimai2/tree/master/docker-compose/apache-debian-uk-ldap).  You can log in as tony_teamlead or anna_admin with the password kitten.

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
        - ADMINPASS=pass123
    volumes:
        - ./local.yaml:/opt/kimai/config/packages/local.yaml
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

  ldap:
    image: osixia/openldap:1.2.2
    environment:
      LDAP_ORGANISATION: Example Comms
      LDAP_DOMAIN: example.com
      LDAP_ADMIN_PASSWORD: changeme
      LDAP_BASE_DN: dc=example,dc=com
    volumes:
        - ./export.ldif:/container/service/slapd/assets/config/bootstrap/ldif/50-bootstrap.ldif
    ports:
        - 389:389
    hostname: ldap
    command: --copy-service
    restart: always

```
