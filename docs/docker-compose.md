# Docker compose

Here are some example docker compose files.

## Simple legacy docker with mysql DB

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
        - mysql:/var/lib/mysql
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

volumes:
  mysql:
```

## Apache/debian docker with mysql db

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
    image: kimai/kimai2:master
    environment:
        - APP_ENV=prod
        - DATABASE_URL=mysql://kimaiu:kimaip@mydb/kimai
        = MAILER_URL="smtp://kimai:kimai@postfix:25/?timeout=60"
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
    
volumes:
  mysql:
```

## NGINX/FPM/debian docker with mysql db

All files [here]()

```yaml
version: '3'
services:

  mydb_nginx:
    image: mysql:5.6
    environment:
      - MYSQL_DATABASE=kimai
      - MYSQL_USER=kimaiu
      - MYSQL_PASSWORD=kimaip
      - MYSQL_ROOT_PASSWORD=changeme
    volumes:
        - mysql_nginx:/var/lib/mysql
    command: --default-storage-engine innodb
    restart: always

  nginx:
    image: nginx:latest
    ports:
        - 8002:80
    volumes:
      - codebase:/opt/shared_kimai
      - ./assets/nginx_site.conf:/etc/nginx/conf.d/default.conf

  kimai_fpm:
    image: kimai/kimai2:fpm-alpine-master
    environment:
        - APP_ENV=dev
        - TRUSTED_HOSTS=localhost
        - DATABASE_URL=mysql://kimaiu:kimaip@mydb_nginx/kimai
        MAILER_URL: "smtp://kimai:kimai@postfix:25/?timeout=60"
        - ADMINMAIL=kimai@example.com
        - ADMINPASS=pass123
    volumes:
      - codebase:/opt/shared_kimai
    entrypoint: /nginx-startup.sh

  postfix:
    image: catatnight/postfix
    environment:
      maildomain: neontribe.co.uk
      smtp_user: kimai:kimai
    restart: unless-stopped
    restart: always

volumes:
  mysql_nginx:
  codebase:

```

## Apache/debian docker with mysql db in a different locale

All files [here]()

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
    image: kimai/kimai2:1.0.1
    environment:
        - APP_ENV=prod
        - DATABASE_URL=mysql://kimaiu:kimaip@mydb/kimai
        MAILER_URL: "smtp://kimai:kimai@postfix:25/?timeout=60"
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

volumes:
  mysql:

```

## Apache/debian docker with mysql db in a different locale and LDAP auth

All files [here]()

```yaml
```
