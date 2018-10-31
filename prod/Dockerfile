# This file is part of the Kimai time-tracking app.
#
# For the full copyright and license information, please view the LICENSE
# file that was distributed with this source code.
 
FROM php:7.2.9-apache-stretch

ARG VERSION=0.5

RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer && \
    apt update && \
    apt install -y \
        git \
        libicu-dev \
        libjpeg-dev \
        libldap2-dev \
        libldb-dev \
        libpng-dev \
        unzip \
        zip \
        && \
    docker-php-ext-install \
        gd \
        intl \
        ldap \
        pdo_mysql \
        zip \
        && \
    docker-php-ext-install \
        gd \
        intl \
        ldap \
        pdo_mysql \
        zip && \
    apt-get -y autoremove && \
    apt-get clean

ADD https://github.com/kevinpapst/kimai2/archive/${VERSION}.tar.gz /tmp/kimai.tgz
RUN tar -zxf /tmp/kimai.tgz --strip-components=2 -C /opt/kimai
WORKDIR /opt/kimai
RUN composer install

ENV PORT=80

EXPOSE 80 443

USER www-data
ENTRYPOINT /bin/bash
# CMD /opt/kimai/bin/console server:run 0.0.0.0:8001
