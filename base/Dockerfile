FROM php:7.2.9-apache-stretch

RUN apt update && \
    apt install -y --allow-unauthenticated \
        git \
        haveged \
        libicu-dev \
        libjpeg-dev \
        libldap2-dev \
        libldb-dev \
        libpng-dev \
        mysql-client \
        unzip \
        wget \
        zip \
        && \
    EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)" && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")" && \
    if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then >&2 echo 'ERROR: Invalid installer signature'; rm composer-setup.php; exit 1; fi && \
    php composer-setup.php --quiet && \
    rm composer-setup.php && \
    mv /var/www/html/composer.phar /usr/bin/composer && \
    docker-php-ext-install \
        gd \
        intl \
        ldap \
        pdo_mysql \
        zip && \
    apt remove -y wget && \
    apt -y autoremove && \
    apt clean
