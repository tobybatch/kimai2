
## Reset and clean

    docker-compose stop && docker-compose rm && docker volume prune

## Apache/Kimai dev/sqlite

    docker-compose -f docker-compose.base.yml -f docker-compose.apache.dev.yml up

## Apache/Kimai prod/sqlite

    docker-compose -f docker-compose.base.yml -f docker-compose.apache.dev.yml -f docker-compose.apache.prod.yml up

## Apache/Kimai dev/mysql

    docker-compose -f docker-compose.base.yml -f docker-compose.apache.dev.yml -f docker-compose.mysql.yml up

## Apache/Kimai prod/mysql

    docker-compose -f docker-compose.base.yml -f docker-compose.apache.dev.yml -f docker-compose.apache.prod.yml -f docker-compose.mysql.yml up

## FPM/Kimai dev/sqlite

    docker-compose -f docker-compose.base.yml -f docker-compose.fpm.dev.yml -f docker-compose.nginx.yml -f docker-compose.nginx.yml up

## FPM/Kimai prod/sqlite

    docker-compose -f docker-compose.base.yml -f docker-compose.fpm.prod.yml -f docker-compose.nginx.yml -f docker-compose.nginx.yml up

## FPM/Kimai dev/mysql

    docker-compose -f docker-compose.base.yml -f docker-compose.fpm.dev.yml -f docker-compose.nginx.yml -f docker-compose.nginx.yml -f docker-compose.mysql.yml up

## FPM/Kimai prod/mysql

    docker-compose -f docker-compose.base.yml -f docker-compose.fpm.prod.yml -f docker-compose.nginx.yml -f docker-compose.nginx.yml -f docker-compose.mysql.yml up

