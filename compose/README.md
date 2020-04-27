# Readme

## Reset and clean

```sh
docker-compose stop && docker-compose rm && docker volume prune
```

## Apache/Kimai dev/sqlite

```sh
docker-compose -f docker-compose.base.yml -f docker-compose.apache.dev.yml up
```

## Apache/Kimai prod/sqlite

```sh
docker-compose -f docker-compose.base.yml -f docker-compose.apache.prod.yml up
```

## Apache/Kimai dev/mysql

```sh
docker-compose -f docker-compose.base.yml -f docker-compose.apache.dev.yml -f docker-compose.mysql.yml up
```

## Apache/Kimai prod/mysql

```sh
docker-compose -f docker-compose.base.yml -f docker-compose.apache.prod.yml -f docker-compose.mysql.yml up
```

## FPM/Kimai dev/sqlite

```sh
docker-compose -f docker-compose.base.yml -f docker-compose.fpm.dev.yml -f docker-compose.nginx.yml up
```

## FPM/Kimai prod/sqlite

```sh
docker-compose -f docker-compose.base.yml -f docker-compose.fpm.prod.yml -f docker-compose.nginx.yml up
```

## FPM/Kimai dev/mysql

```sh
docker-compose -f docker-compose.base.yml -f docker-compose.fpm.dev.yml -f docker-compose.nginx.yml -f docker-compose.mysql.yml up
```

## FPM/Kimai prod/mysql

```sh
docker-compose -f docker-compose.base.yml -f docker-compose.fpm.prod.yml -f docker-compose.nginx.yml -f docker-compose.mysql.yml up
```

## Apache/Kimai dev/sqlite/LDAP

```sh
docker-compose -f docker-compose.base.yml -f docker-compose.apache.dev.yml -f docker-compose.ldap.yml up
```

## FPM/Kimai dev/sqlite/LDAP

```sh
docker-compose -f docker-compose.base.yml -f docker-compose.fpm.dev.yml -f docker-compose.nginx.yml -f docker-compose.ldap.yml up
```
