FROM php:7.3.6-fpm-alpine3.10

RUN apk --no-cache add \
        git \
        haveged \
        ldb \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        g++ \
        mysql-client \
        unzip \
        wget \
        icu-dev \
        openldap-dev \
        libzip-dev \
        zip && \
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
        zip
