# Runtime config

## Environment variables

You can override settings at run time, e.g.:

    docker run --rm -ti \
        -p 8001:8001 \
        --name kimai2 \
        -e MAILER_FROM=me@example.com \
        -e APP_ENV=dev \
        -e APP_SECRET=shhh_no_one_will_guess_this \
        -e TRUSTED_PROXIES=192.0.0.1 \
        -e TRUSTED_HOSTS=localhost \
        -e DATABASE_URL=mysql://kimaiu:kimaip@mydb/kimai \ # | DATABASE_URL=sqlite:///%kernel.project_dir%/var/data/kimai.sqlite
        -e ADMINMAIL=kimai@neontribe.co.uk \
        -e ADMINPASS=changeme \
        -e MAILER_URL=smtp://user:pass@host:port/?timeout=60&encryption=ssl&auth_mode=login \
        kimai/kimai2:0.9

### Kimai default env vars:

see [https://github.com/kevinpapst/kimai2].

 * MAILER_FROM
   Default: ```kimai@example.com```
   The from address for mails from the system.

### Symfony framework bundle

see [https://symfony.com/doc/current/reference/configuration/framework.html].

 * APP_ENV
   Default: ```prod```
 * APP_SECRET
   Default: ```change_this_to_something_unique```
 * TRUSTED_PROXIES
   Default: Not set by default
 * TRUSTED_HOSTS
   Default: Not set by default

### Doctrine bundle

see [https://symfony.com/doc/current/reference/configuration/doctrine.html].

**Database Passwords**

Database configurations are set using a url schema.  If you use a password that contains character like /, \ or @ Kimai will not work as it can't parse the URL.  I will add protection for this but not in the near future.  I am very happy to accept a patch that will do that for me.

Default: ```sqlite:///%kernel.project_dir%/var/data/kimai.sqlite```

or it can be customised: ```mysql://kimaiu:kimaip@mydb/kimai```

### Swiftmailer bundle

see [https://symfony.com/doc/current/reference/configuration/swiftmailer.html]

 * MAILER_URL
   Default: ```null://localhost```
