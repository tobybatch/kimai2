ARG BASE="fpm-alpine"

###########################
# Shared tools
###########################

# full kimai source
FROM alpine:3.10 AS git-dev
ARG KIMAI="1.4.1"
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
# fpm-alpine base build
###########################

# php extension gd
FROM php:7.3.10-fpm-alpine3.10 AS fpm-alpine-ext-gd
RUN apk add --no-cache libpng-dev freetype-dev && \
    #     #libjpeg-turbo-dev \
    #     #libpng-dev \
    #     #libpng-dev \
    #     #libwebp-dev \
    #     #libxpm-dev \
    #     && \
    docker-php-ext-configure gd \
        --with-freetype-dir \
    #    #--with-gd \
    #    #--with-jpeg-dir \
    #    #--with-png-dir \
    #    #--with-webp-dir \
    #    #--with-xpm-dir \
    #    #--with-zlib-dir \
        && \
    docker-php-ext-install -j$(nproc) gd

# php extension intl
FROM php:7.3.10-fpm-alpine3.10 AS fpm-alpine-ext-intl
RUN apk add --no-cache icu-dev && \
    docker-php-ext-install -j$(nproc) intl

# php extension pdo_mysql
FROM php:7.3.10-fpm-alpine3.10 AS fpm-alpine-ext-pdo_mysql
RUN docker-php-ext-install -j$(nproc) pdo_mysql

# php extension zip
FROM php:7.3.10-fpm-alpine3.10 AS fpm-alpine-ext-zip
RUN apk add --no-cache libzip-dev && \
    docker-php-ext-install -j$(nproc) zip

# fpm-alpine base build
FROM php:7.3.10-fpm-alpine3.10 AS fpm-alpine-base
RUN apk add --no-cache \
        bash \
        haveged \
        icu \
        libpng \
        libzip \
        freetype
        #libjpeg-turbo \
        #libpng \
        #libpng \
        #libwebp \
        #libxpm

# copy php extensions
# PHP extension gd
COPY --from=fpm-alpine-ext-gd /usr/local/etc/php/conf.d/docker-php-ext-gd.ini /usr/local/etc/php/conf.d/docker-php-ext-gd.ini
COPY --from=fpm-alpine-ext-gd /usr/local/lib/php/extensions/no-debug-non-zts-20180731/gd.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731/gd.so
# PHP extension intl
COPY --from=fpm-alpine-ext-intl /usr/local/etc/php/conf.d/docker-php-ext-intl.ini /usr/local/etc/php/conf.d/docker-php-ext-intl.ini
COPY --from=fpm-alpine-ext-intl /usr/local/lib/php/extensions/no-debug-non-zts-20180731/intl.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731/intl.so
# PHP extension pdo_mysql
COPY --from=fpm-alpine-ext-pdo_mysql /usr/local/etc/php/conf.d/docker-php-ext-pdo_mysql.ini /usr/local/etc/php/conf.d/docker-php-ext-pdo_mysql.ini
COPY --from=fpm-alpine-ext-pdo_mysql /usr/local/lib/php/extensions/no-debug-non-zts-20180731/pdo_mysql.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731/pdo_mysql.so
# PHP extension zip
COPY --from=fpm-alpine-ext-zip /usr/local/etc/php/conf.d/docker-php-ext-zip.ini /usr/local/etc/php/conf.d/docker-php-ext-zip.ini
COPY --from=fpm-alpine-ext-zip /usr/local/lib/php/extensions/no-debug-non-zts-20180731/zip.so /usr/local/lib/php/extensions/no-debug-non-zts-20180731/zip.so


###########################
# global base build
###########################

FROM ${BASE}-base AS base

ARG KIMAI="1.4.1"
ENV KIMAI=${KIMAI}

ARG TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone && \
    chown -R www-data:www-data /etc/localtime /etc/timezone && \
    touch /use_fpm

# drop root permissions
USER www-data

# copy startup script
COPY startup.sh /startup.sh

# copy composer
COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY --from=composer --chown=www-data:www-data /opt/kimai/vendor /opt/kimai/vendor

ENV DATABASE_URL=sqlite:///%kernel.project_dir%/var/data/kimai.sqlite
ENV MAILER_FROM=kimai@example.com
ENV APP_ENV=prod
ENV APP_SECRET=change_this_to_something_unique
ENV TRUSTED_PROXIES=false
ENV TRUSTED_HOSTS=false
ENV MAILER_URL=null://localhost
ENV ADMINPASS=
ENV ADMINMAIL=
ENV TZ=${TZ}
ENV KIMAI=${KIMAI}

EXPOSE 8001

ENTRYPOINT /startup.sh


###########################
# final builds
###########################

# fpm-alpine developement build
FROM base AS fpm-alpine-dev
# copy kimai source
COPY --from=git-dev --chown=www-data:www-data /opt/kimai /opt/kimai
# do the composer deps installation
RUN composer install --working-dir=/opt/kimai --optimize-autoloader && \
    composer clearcache

# fpm-alpine production build
FROM base AS fpm-alpine-prod
# copy kimai source
COPY --from=git-prod --chown=www-data:www-data /opt/kimai /opt/kimai
# do the composer deps installation
RUN composer install --working-dir=/opt/kimai --no-dev --optimize-autoloader && \
    composer clearcache