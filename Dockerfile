#  _  ___                 _ ____  
# | |/ (_)_ __ ___   __ _(_)___ \ 
# | ' /| | '_ ` _ \ / _` | | __) |
# | . \| | | | | | | (_| | |/ __/ 
# |_|\_\_|_| |_| |_|\__,_|_|_____|
#                                 

# Source base [fpm-alpine/apache-debian]
ARG BASE="fpm-alpine"

###########################
# Shared tools
###########################

# full kimai source
FROM alpine:3.10 AS git-dev
ARG KIMAI="1.6"
RUN apk add --no-cache git && \
    git clone --depth 1 --branch ${KIMAI} https://github.com/kevinpapst/kimai2.git /opt/kimai

# production kimai source
FROM git-dev AS git-prod
WORKDIR /opt/kimai
RUN rm -r tests

# composer with prestissimo (faster deps install)
FROM composer:1.9 AS composer
RUN mkdir /opt/kimai && \
    composer require --working-dir=/opt/kimai hirak/prestissimo



###########################
# PHP extensions
###########################

#fpm alpine php extension base
FROM php:7.3.10-fpm-alpine3.10 AS fpm-alpine-php-ext-base
RUN apk add --no-cache \
    # build-tools
    autoconf \
    dpkg \
    dpkg-dev \
    file \
    g++ \
    gcc \
    libatomic \
    libc-dev \
    libgomp \
    libmagic \
    m4 \
    make \
    mpc1 \
    mpfr3 \
    musl-dev \
    perl \
    re2c \
    # gd
    freetype-dev \
    libpng-dev \
    # icu
    icu-dev \
    # ldap
    openldap-dev \
    libldap \
    # zip
    libzip-dev


# apache debian php extension base
FROM php:7.3.10-apache-buster AS apache-debian-php-ext-base
RUN apt-get update
RUN apt-get install -y \
        libldap2-dev \
        libicu-dev \
        libpng-dev \
        libzip-dev \
        libfreetype6-dev


# php extension gd - 13.86s
FROM ${BASE}-php-ext-base AS php-ext-gd
RUN docker-php-ext-configure gd \
        --with-freetype-dir && \
    docker-php-ext-install -j$(nproc) gd

# php extension intl : 15.26s
FROM ${BASE}-php-ext-base AS php-ext-intl
RUN docker-php-ext-install -j$(nproc) intl

# php extension ldap : 8.45s
FROM ${BASE}-php-ext-base AS php-ext-ldap
RUN docker-php-ext-configure ldap && \
    docker-php-ext-install -j$(nproc) ldap

# php extension pdo_mysql : 6.14s
FROM ${BASE}-php-ext-base AS php-ext-pdo_mysql
RUN docker-php-ext-install -j$(nproc) pdo_mysql

# php extension zip : 8.18s
FROM ${BASE}-php-ext-base AS php-ext-zip
RUN docker-php-ext-install -j$(nproc) zip

###########################
# fpm-alpine base build
###########################

# fpm-alpine base build
FROM php:7.3.10-fpm-alpine3.10 AS fpm-alpine-base
RUN apk add --no-cache \
        bash \
        freetype \
        haveged \
        icu \
        libldap \
        libpng \
        libzip && \
    touch /use_fpm

EXPOSE 9000



###########################
# apache-debian base build
###########################

FROM php:7.3.10-apache-buster AS apache-debian-base
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN apt-get update && \
    apt-get install -y \
        bash \
        haveged \
        libicu63 \
        libpng16-16 \
        libzip4 \
        libfreetype6 && \
    echo "Listen 8001" > /etc/apache2/ports.conf && \
    a2enmod rewrite && \
    touch /use_apache

EXPOSE 8001



###########################
# global base build
###########################

FROM ${BASE}-base AS base
LABEL maintainer="tobias@neontribe.co.uk"
LABEL maintainer="bastian@schroll-software.de"

ARG KIMAI="1.6"
ENV KIMAI=${KIMAI}

ARG TZ=Europe/Berlin
ENV TZ=${TZ}
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone && \
    # make composer home dir
    mkdir /composer  && \
    chown -R www-data:www-data /composer

# copy startup script
COPY startup.sh /startup.sh

# copy composer
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=composer --chown=www-data:www-data /opt/kimai/vendor /opt/kimai/vendor

# copy php extensions

# PHP extension pdo_mysql
COPY --from=php-ext-pdo_mysql /usr/local/etc/php/conf.d/docker-php-ext-pdo_mysql.ini /usr/local/etc/php/conf.d/docker-php-ext-pdo_mysql.ini
COPY --from=php-ext-pdo_mysql /usr/local/lib/php/extensions/no-debug-non-zts-20180731/pdo_mysql.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731/pdo_mysql.so
# PHP extension zip
COPY --from=php-ext-zip /usr/local/etc/php/conf.d/docker-php-ext-zip.ini /usr/local/etc/php/conf.d/docker-php-ext-zip.ini
COPY --from=php-ext-zip /usr/local/lib/php/extensions/no-debug-non-zts-20180731/zip.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731/zip.so
# PHP extension ldap
COPY --from=php-ext-ldap /usr/local/etc/php/conf.d/docker-php-ext-ldap.ini /usr/local/etc/php/conf.d/docker-php-ext-ldap.ini
COPY --from=php-ext-ldap /usr/local/lib/php/extensions/no-debug-non-zts-20180731/ldap.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731/ldap.so
# PHP extension gd
COPY --from=php-ext-gd /usr/local/etc/php/conf.d/docker-php-ext-gd.ini /usr/local/etc/php/conf.d/docker-php-ext-gd.ini
COPY --from=php-ext-gd /usr/local/lib/php/extensions/no-debug-non-zts-20180731/gd.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731/gd.so
# PHP extension intl
COPY --from=php-ext-intl /usr/local/etc/php/conf.d/docker-php-ext-intl.ini /usr/local/etc/php/conf.d/docker-php-ext-intl.ini
COPY --from=php-ext-intl /usr/local/lib/php/extensions/no-debug-non-zts-20180731/intl.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731/intl.so

ENV DATABASE_URL=sqlite:///%kernel.project_dir%/var/data/kimai.sqlite
ENV APP_SECRET=change_this_to_something_unique
ENV TRUSTED_PROXIES=false
ENV TRUSTED_HOSTS=false
ENV MAILER_FROM=kimai@example.com
ENV MAILER_URL=null://localhost
ENV ADMINPASS=
ENV ADMINMAIL=

VOLUME [ "/opt/kimai/var" ]
WORKDIR /opt/kimai

ENTRYPOINT /startup.sh



###########################
# final builds
###########################

# developement build
FROM base AS dev
# copy kimai develop source
COPY --from=git-dev --chown=www-data:www-data /opt/kimai /opt/kimai
# do the composer deps installation
RUN export COMPOSER_HOME=/composer && \
    composer install --working-dir=/opt/kimai --optimize-autoloader && \
    composer clearcache && \
    chown -R www-data:www-data /opt/kimai
RUN composer require --working-dir=/opt/kimai zendframework/zend-ldap
USER www-data

# production build
FROM base AS prod
# copy kimai production source
COPY --from=git-prod --chown=www-data:www-data /opt/kimai /opt/kimai
# do the composer deps installation
RUN export COMPOSER_HOME=/composer && \
    composer install --working-dir=/opt/kimai --no-dev --optimize-autoloader && \
    composer require --working-dir=/opt/kimai zendframework/zend-ldap && \
    composer clearcache && \
    chown -R www-data:www-data /opt/kimai
USER www-data
