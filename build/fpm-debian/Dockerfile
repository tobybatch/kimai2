FROM kimai/kimai2_base:fpm-debian
LABEL maintainer="tobias@neontribe.co.uk"

# The FPM image will need to me root to fix some poerms at runtime
USER root
ARG TZ=Europe/London
ARG TAG=1.4

RUN git clone --branch ${TAG} https://github.com/kevinpapst/kimai2.git /opt/kimai && \
    composer install --working-dir=/opt/kimai --dev --optimize-autoloader && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    composer require --working-dir=/opt/kimai zendframework/zend-ldap && \
    chown -R www-data:www-data /opt /etc/localtime /etc/timezone && \
    touch /use_fpm

WORKDIR /opt/kimai
ADD startup.sh /startup.sh
ADD nginx-startup.sh /nginx-startup.sh
ADD url_parse.php /url_parse.php

USER www-data

ENV DATABASE_URL=sqlite:///%kernel.project_dir%/var/data/kimai.sqlite
ENV MAILER_FROM=kimai@example.com
ENV APP_ENV=prod
ENV APP_SECRET=change_this_to_something_unique
ENV TRUSTED_PROXIES=false
ENV TRUSTED_HOSTS=false
ENV MAILER_URL=null://localhost
ENV ADMINPASS=
ENV ADMINMAIL=

EXPOSE 8001

ENV TZ=Europe/London

ENTRYPOINT /nginx-startup.sh

# vim: syntax=dockerfile ts=4 sw=4 sts=4 sr noet
