FROM kimai/kimai2:dev
LABEL maintainer="tobias@neontribe.co.uk"

USER root
ARG TZ=Europe/London

ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
RUN apt update && apt install -y mysql-client vim sudo && \
    apt-get -y autoremove && apt-get clean && \
    touch .env && \
    chown -R www-data:www-data .env var /etc/apache2/sites-available /etc/localtime /etc/timezone && \
    echo "Listen 8001" > /etc/apache2/ports.conf && \
    a2enmod rewrite
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ADD startup.sh /startup.sh
ADD url_parse.php /url_parse.php

USER www-data

ENV DATABASE_PREFIX=kimai2_
ENV MAILER_FROM=kimai@example.com
ENV APP_ENV=prod
ENV APP_SECRET=change_this_to_something_unique
ENV TRUSTED_PROXIES=false
ENV TRUSTED_HOSTS=false
ENV MAILER_URL=null://localhost

# These are ignored unless the DATABASE_URL above is set to mysql
ENV SQL_PROTOCOL=sqlite
ENV SQL_DATABASE=%kernel.project_dir%/var/data/kimai.sqlite
ENV SQL_USER=
ENV SQL_PASSWORD=
ENV SQL_HOST=

EXPOSE 8001

ENV TZ=Europe/London

ENTRYPOINT /startup.sh
