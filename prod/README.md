# Kimai docker

See the kimai repository for more setails on all options. https://github.com/kevinpapst/kimai2

    docker run --rm -ti -p 8080:8080 --name kimai2 kimai/kimai2

## Runtime args

You can ovverride settings at run time, e.g.:

    docker run --rm -ti \
        -p 8080:8080 \
        --name kimai2 \
        -e DATABASE_PREFIX=foo_ \
        -e MAILER_FROM=me@example.com \
        -e APP_ENV=dev \
        -e APP_SECRET=shhh_no_one_will_guess_this \
        -e TRUSTED_PROXIES=192.0.0.1 \
        -e TRUSTED_HOSTS=localhost \
        -e DATABASE_URL=mysql://user:pass@host/database \
        -e MAILER_URL=smtp://user:pass@host:port/?timeout=60&encryption=ssl&auth_mode=login \
        kimai/kimai2:prod

** Kimai default env vars, see [https://github.com/kevinpapst/kimai2](here).
 * DATABASE_PREFIX
   Default: ```kimai2_```
   The table prefix in the database.
 * MAILER_FROM
   Default: ```kimai@example.com```
   The from address for mails from the system.

** Symfony framework bundle, see [https://symfony.com/doc/current/reference/configuration/framework.html](here).
 * APP_ENV
   Default: ```prod```
 * APP_SECRET
   Default: ```change_this_to_something_unique```
 * TRUSTED_PROXIES
   Default: Not set by default
 * TRUSTED_HOSTS
   Default: Not set by default

** Doctrine bundle, see [https://symfony.com/doc/current/reference/configuration/doctrine.html](here).
 * DATABASE_URL
   Default: ```sqlite:///%kernel.project_dir%/var/data/kimai.sqlite```

** Swiftmailer bundle, see [https://symfony.com/doc/current/reference/configuration/swiftmailer.html](here).
 * MAILER_URL
   Default: ```null://localhost```

## Create a user

    docker exec -ti kimai2 bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN admin
