# Docker compose

Run a production Kimai with a persistent database in a separate mysql container.

You can hit kimai at `http://localhost:8001` and log in with `superadmin` / `changemeplease`.

```yaml
version: '3.5'
services:

  sqldb:
    image: mysql:5.7
    environment:
      - MYSQL_DATABASE=kimai
      - MYSQL_USER=kimaiuser
      - MYSQL_PASSWORD=kimaipassword
      - MYSQL_ROOT_PASSWORD=changemeplease
    volumes:
      - /var/lib/mysql
    command: --default-storage-engine innodb
    restart: unless-stopped
    healthcheck:
      test: mysqladmin -pchangemeplease ping -h localhost
      interval: 20s
      start_period: 10s
      timeout: 10s
      retries: 3

  nginx:
    build: compose
    ports:
      - 8001:80
    volumes:
      - ./nginx_site.conf:/etc/nginx/conf.d/default.conf:ro
      - public:/opt/kimai/public:ro
    restart: unless-stopped
    depends_on:
      - kimai
    healthcheck:
      test:  wget --spider http://nginx/health || exit 1
      interval: 20s
      start_period: 10s
      timeout: 10s
      retries: 3

  kimai:
    image: kimai/kimai2:fpm-alpine-1.10.2-prod
    environment:
      - APP_ENV=prod
      - TRUSTED_HOSTS=localhost,nginx,${HOSTNAME}
      - ADMINMAIL=admin@kimai.local
      - ADMINPASS=changemeplease
      - DATABASE_URL=mysql://kimaiuser:kimaipassword@sqldb/kimai
    volumes:
      - public:/opt/kimai/public # << You must use a named volume, see note below
      - var:/opt/kimai/var
      # - ./ldap.conf:/etc/openldap/ldap.conf:z
      # - ./ROOT-CA.pem:/etc/ssl/certs/ROOT-CA.pem:z
    restart: unless-stopped

  postfix:
    image: catatnight/postfix:latest
    environment:
      maildomain: kimai.local
      smtp_user: kimai:kimai
    restart: unless-stopped

volumes:
    var:
    public:
```

**You must use a named volume**

In order for the "public" folder to get copied correctly, this must be a "named" volume, not a folder path. You will get a 404 if you don't use a named volume. If you MUST use a folder path, this is what you must do:

1. First, you need to change the volume map to `- ./my/folder:/opt/kimai/public2` (notice the "2" at the end)
2. Now, `docker-compose up -d`, and then `docker-compose exec kimai bash` and inside that container `cd /opt/kimai && cp -r public/* public2/ && cp -r public/.htaccess public2/`
3. Finally, change back the docker-compose to `- ./my/folder:/opt/kimai/public` (no more "2") and `docker-compose up -d`
