# Runtime Arguments

The following settings can set at runtime:

Kimai/symfony core settings, see the symfony and Kimai docs for more info on these.

```bash
DATABASE_URL=sqlite:///%kernel.project_dir%/var/data/kimai.sqlite
APP_SECRET=change_this_to_something_unique
TRUSTED_PROXIES=nginx,localhost,127.0.0.1
TRUSTED_HOSTS=nginx,localhost,127.0.0.1
MAILER_FROM=kimai@example.com
MAILER_URL=null://localhost
```

Start up values:

If set then these values will try and create a new admin user.

```bash
ADMINPASS=
ADMINMAIL=
```

## Alternate DB config

It is possible to pass the DB config in individual values.  If the ENV variable ```DB_TYPE``` is set then the following values will be expected:

If the ```DB_TYPE``` is mysql:

 * ```DB_USER``` defaults to ```kimai```
 * ```DB_PASS``` defaults to ```kimai```
 * ```DB_HOST``` defaults to ```sqldb```
 * ```DB_PORT``` defaults to ```3306```
 * ```DB_BASE``` defaults to ```kimai```

If the ```DB_TYPE``` is sqlite:

 * ```DB_BASE``` defaults to ```%kernel.project_dir%/var/data/kimai.sqlite```, N.B. This should be the path relative to ```/opt/kimai```, prefix this with a ```/``` to path it from the root of the image.

Anything else and startup will fail.
