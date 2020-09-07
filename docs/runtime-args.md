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
