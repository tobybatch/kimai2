## Kimai Dockers

[![Build Status](https://travis-ci.org/tobybatch/kimai2.svg?branch=master)](https://travis-ci.org/tobybatch/kimai2)

## Dockerhub

Docker hub hosts a number of tagged releases, starting with 0.8.  These are all build against a production docker file that will function best with an external MYSQL DB.

In addition there a dev image that is built for development / quick test purposes. 

## Why no NGINX?

This image uses apache because apache can run php as a module.  Nginx can't run php, it needs to pass the php request to a fast cgi process.  Dockers are supposed to be single thread processes and to run nginx you need at leat two, then probably some sysinit deamon, then a logger gets added.

## Development docker

### Building

```bash
 docker build -t kimai/kimai2:dev --rm .
```

### Starting the docker (sqlite)

```bash
docker run --rm -ti -p 8001:8001 --name kimai2 kimai/kimai2:dev
docker exec kimai2 bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN admin
```

## Production docker

### Building

Each of the folders in the tag folder hold a build for a different tag.  You can build any tag by passing it to the docker build command. e.g.

```bash
 docker build -t kimai/kimai2:prod --build-arg "TAG=0.9" --rm tags/0.9
```

Use the latest tag for the most stable conatiner, the passed TAG arg will override the version of kimai built.

### Starting the docker (sqlite)

```bash
docker run --rm -ti -p 8001:8001 --name kimai2 kimai/kimai2:0.9
docker exec kimai2 bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN admin
```

### Starting the docker (mysql)

The prod image will require an external mysql db to store the kimai data.  Pass one via the DATABASE_URL runtime argument. e.g.

```bash
docker run -ti -p 8001:8001 --name kimai2 \
    -e DATABASE_URL=mysql://kimai_user:kimai_pass@somehost/kimai_db \
    kimai/kimai2:0.9
```

### Docker compose

```yaml
version: '3'
services:

  mysql:
    image: mysql:5.7
    environment:
      - MYSQL_DATABASE=kimai
      - MYSQL_USER=kimai
      - MYSQL_PASSWORD=kimai
      - MYSQL_ROOT_PASSWORD=changeme
    volumes:
        - mysql:/var/lib/mysql
    command: --default-storage-engine innodb --secure-file-priv=/var/tmp/
    restart: always

  kimai:
    image: kimai/kimai2:1.0
    environment:
        APP_ENV: prod
        APP_SECRET: some-thing-really-secret
        DATABASE_URL: mysql://kimai:kimai@mysql/kimai
        MAILER_FROM: kimai@neontribe.co.uk
        MAILER_URL: "smtp://kimai:kimai@postfix:25/?timeout=60"
        ADMINMAIL: kimai@neontribe.co.uk
        ADMINPASS: changeme
    volumes:
        - ./local.yaml:/opt/kimai/config/packages/local.yaml
    depends_on:
        - mysql
    ports:
        - 9010:8001
    restart: always

  postfix:
    image: catatnight/postfix
    environment:
      maildomain: neontribe.co.uk
      smtp_user: kimai:kimai
    restart: unless-stopped
    restart: always

volumes:
  mysql:
```

And then you can override the kimai things you need to in the local.yml

```yaml
kimai:
    defaults:
        customer:
            timezone: Europe/London
            country: GB
            currency: GBP

    timesheet:
        mode: duration_only

    ldap:
        # more infos about the connection params can be found at:
        # https://docs.zendframework.com/zend-ldap/api/
        # https://www.kimai.org/documentation/ldap.html
        connection:
            host: 10.0.21.5
            #port: 389
            #useSsl: false
            #useStartTls: false
            username: cn=admin,dc=neontribe,dc=net
            password: 55hTh151sr3ally53cr3t
            #accountFilterFormat: (&(objectClass=inetOrgPerson)(uid=%s))
            #bindRequiresDn: true
            optReferrals: false
            #allowEmptyPassword: false
            #tryUsernameSplit:
            #networkTimeout:
            #accountCanonicalForm: 3
            #accountDomainName: HOST
            #accountDomainNameShort: HOST

        user:
            baseDn: ou=users,dc=neontribe,dc=net
            usernameAttribute: uid
            # filter: (&(objectClass=inetOrgPerson))
            #attributesFilter: (objectClass=Person)
            attributes:
                - { ldap_attr: "uid", user_method: setUsername }
                - { ldap_attr: "mail", user_method: setEmail }
                - { ldap_attr: cn, user_method: setAlias }
        role:
            baseDn: ou=groups,dc=neontribe,dc=net
            filter: (&(objectClass=posixGroup))
            usernameAttribute: memberUid
            nameAttribute: cn
            userDnAttribute: dn
            groups:
                - { ldap_value: kimai-teamleader, role: ROLE_TEAMLEAD }
                - { ldap_value: kimai-admin, role: ROLE_ADMIN }
                - { ldap_value: kimai_superadmin, role: ROLE_SUPERADMIN }

    # Remove local passwords
    user:
        registration: false
        password_reset: false
    permissions:
        roles:
            ROLE_USER: ['!password_own_profile']
            ROLE_TEAMLEAD: ['!password_own_profile']
            ROLE_ADMIN: ['!password_own_profile']

security:
    providers:
        chain_provider:
            chain:
                providers: [kimai_ldap]
    firewalls:
        secured_area:
            kimai_ldap: ~

```

To customise the image you can mout a local.yml into it:

```yaml
version: '3'
services:

  mysql:
    image: mysql:5.7
    environment:
      - MYSQL_DATABASE=kimai
      - MYSQL_USER=kimai
      - MYSQL_PASSWORD=kimai
      - MYSQL_ROOT_PASSWORD=changeme
    volumes:
        - mysql:/var/lib/mysql
    command: --default-storage-engine innodb --secure-file-priv=/var/tmp/
    restart: always

  kimai:
    image: kimai/kimai2:1.0
    environment:
        APP_ENV: prod
        APP_SECRET: IBt9MSlk7Onbtn3JYJQ3cJmKZTcJIOOfNSeNpRZB9083DZ2Z
        DATABASE_URL: mysql://kimai:kimai@mysql/kimai
        MAILER_FROM: kimai@neontribe.co.uk
        MAILER_URL: "smtp://kimai:kimai@postfix:25/?timeout=60"
    volumes:
        - ./local.yaml:/opt/kimai/config/packages/local.yaml
    depends_on:
        - mysql
    ports:
        - 9010:8001
    restart: always

  postfix:
    image: catatnight/postfix
    environment:
      maildomain: neontribe.co.uk
      smtp_user: kimai:kimai
    restart: unless-stopped
    restart: always

volumes:
  mysql:
```

And here is a sample yaml file to override a set of values:

local.yaml

### Runtime args

**Database Passwords**

Database configurations are set using a url schema.  If you use a password that contains character like /, \ or @ Kimai will not work as it can't parse the URL.  I will add protection for this but not in the near future.  I am very happy to accept a patch that will do that for me.

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

#### Create admin user:

If both the environment variables ```ADMINPASS``` and ```ADMINMAIL``` are set then a user name ```superadmin``` will be created on start up.  If this is not used then this command will create the user:

    docker-compose exec kimai bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN admin

#### Kimai default env vars:

see [https://github.com/kevinpapst/kimai2].

 * MAILER_FROM
   Default: ```kimai@example.com```
   The from address for mails from the system.

#### Symfony framework bundle

see [https://symfony.com/doc/current/reference/configuration/framework.html].

 * APP_ENV
   Default: ```prod```
 * APP_SECRET
   Default: ```change_this_to_something_unique```
 * TRUSTED_PROXIES
   Default: Not set by default
 * TRUSTED_HOSTS
   Default: Not set by default

#### Doctrine bundle

see [https://symfony.com/doc/current/reference/configuration/doctrine.html].

The old DATABASE_URL is back!

Default: ```sqlite:///%kernel.project_dir%/var/data/kimai.sqlite```

or it can be customised: ```mysql://kimaiu:kimaip@mydb/kimai```

#### Swiftmailer bundle

see [https://symfony.com/doc/current/reference/configuration/swiftmailer.html]

 * MAILER_URL
   Default: ```null://localhost```

### Create a user

    docker exec -ti kimai2 bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN admin

