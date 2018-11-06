FROM kimai/kimai2:dev
LABEL maintainer="tobias@neontribe.co.uk"

USER root
RUN apt update && apt install -y mysql-client && \
    apt install -y vim && \
    apt-get -y autoremove && apt-get clean && \
    touch .env && \
    chown -R www-data:www-data .env var && \
    echo "Listen 8080" > /etc/apache2/ports.conf
RUN a2enmod rewrite

ADD 000-default.conf /etc/apache2/sites-enabled/000-default.conf
ADD startup.sh /startup.sh

USER www-data

ENV DATABASE_PREFIX=kimai2_
ENV MAILER_FROM=kimai@example.com
ENV APP_ENV=prod
ENV APP_SECRET=change_this_to_something_unique
ENV TRUSTED_PROXIES=false
ENV TRUSTED_HOSTS=false
ENV DATABASE_URL=sqlite:///%kernel.project_dir%/var/data/kimai.sqlite
ENV MAILER_URL=null://localhost

EXPOSE 8080

ENTRYPOINT /startup.sh
