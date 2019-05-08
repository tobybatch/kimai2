FROM kimai/kimai2_base
LABEL maintainer="tobias@neontribe.co.uk"

USER root
ARG TZ=Europe/London
ARG TAG=0.9

ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN git clone --branch ${TAG} https://github.com/kevinpapst/kimai2.git /opt/kimai && \
    sed "s/prod/dev/g" /opt/kimai/.env.dist > /opt/kimai/.env && \
    composer install --working-dir=/opt/kimai --dev --optimize-autoloader && \
    /opt/kimai/bin/console doctrine:database:create
WORKDIR /opt/kimai
RUN chown -R www-data:www-data /opt/kimai/var && \
    touch .env && \
    chown -R www-data:www-data \
      .env \
      var \
      vendor/mpdf/mpdf/tmp \
      /etc/apache2/sites-available \
      /etc/localtime \
      /etc/timezone && \
    echo "Listen 8001" > /etc/apache2/ports.conf && \
    a2enmod rewrite && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD startup.sh /startup.sh
ADD url_parse.php /url_parse.php

USER www-data

ENV DATABASE_URL=sqlite:///%kernel.project_dir%/var/data/kimai.sqlite
ENV MAILER_FROM=kimai@example.com
ENV APP_ENV=prod
ENV APP_SECRET=change_this_to_something_unique
ENV TRUSTED_PROXIES=false
ENV TRUSTED_HOSTS=false
ENV MAILER_URL=null://localhost

EXPOSE 8001

ENV TZ=Europe/London

ENTRYPOINT /startup.sh
