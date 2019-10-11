FROM kimai/kimai2_base:apache-debian
LABEL maintainer="tobias@neontribe.co.uk"
LABEL maintainer="bastian@schroll-software.de"

ARG TZ=Europe/London
ARG TAG=1.4

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN git clone --branch ${TAG} https://github.com/kevinpapst/kimai2.git /opt/kimai && \
    composer install --working-dir=/opt/kimai --dev --optimize-autoloader && \
    touch .env && \
    echo "Listen 8001" > /etc/apache2/ports.conf && \
    a2enmod rewrite && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    composer require --working-dir=/opt/kimai zendframework/zend-ldap && \
    chown -R www-data:www-data /opt /etc/apache2/sites-available /etc/localtime /etc/timezone && \
	touch /use_apache

COPY startup.sh /startup.sh
COPY url_parse.php /url_parse.php

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
ENV TZ=$TZ

EXPOSE 8001

ENTRYPOINT /startup.sh

# vim: syntax=dockerfile ts=4 sw=4 sts=4 sr noet