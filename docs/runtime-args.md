# Runtime Arguments

The following settings can set at runtime:

## PHP Settings

### Memory limit

the Maximum amount of memory a script may consume, <https://php.net/memory-limit>

```bash
memory_limit=512
```

## Kimai/symfony core settings

See the symfony and Kimai docs for more info on these.

```bash
DATABASE_URL=mysql://user:pass@hodt/dbname
APP_SECRET=change_this_to_something_unique
TRUSTED_PROXIES=nginx,localhost,127.0.0.1
TRUSTED_HOSTS=nginx,localhost,127.0.0.1
MAILER_FROM=kimai@example.com
MAILER_URL=null://localhost
```

Start up values:

If set, then these values will be used to create a new admin user (if not yet existing).

```bash
ADMINPASS=
ADMINMAIL=
```

## Changing UID and GID

It is possible to set the user that FPM or Apache run as. If the user does not exist a new user called www-kimai is created and the server is then run under that user. Note these must be numbers, not names.

```bash
USER_ID=1000
GROUP_ID=1000
```

## Alternate DB config

It is possible to pass the DB config in individual values.  If the ENV variable ```DB_TYPE``` is set then the following values will be expected:

The ```DB_TYPE``` must be `mysql`:

* ```DB_USER``` defaults to ```kimai```
* ```DB_PASS``` defaults to ```kimai```
* ```DB_HOST``` defaults to ```sqldb```
* ```DB_PORT``` defaults to ```3306```
* ```DB_BASE``` defaults to ```kimai```
