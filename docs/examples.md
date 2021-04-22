# Examples

Listed here are example set ups for running the image(s). If you'd like to contribute a new one them please raise a PR for this page.

## docker-compose

[Sample docker compose files](https://github.com/tobybatch/kimai2/tree/main/compose)

Kimai requires a database server, and the docker guidelines advise placing this in a separate container. We can use `docker-compose` to manage the DB and Kimai.

### apache-dev

A server running the dev tools, using an apache server based on a debian image. The debian image has more OS tools than an alpine based one but is far larger.

```dockerfile
version: '3.5'
services:

  sqldb:
    image: mysql:5.7
    environment:
      - MYSQL_DATABASE=kimai
      - MYSQL_USER=kimaiuser
      - MYSQL_PASSWORD=kimaipassword
      - MYSQL_ROOT_PASSWORD=changemeplease
    #volumes: # Uncomment to persist data
      #- /var/lib/mysql
    command: --default-storage-engine innodb
    restart: unless-stopped
    healthcheck:
      test: mysqladmin -p$$MYSQL_ROOT_PASSWORD ping -h localhost
      interval: 20s
      start_period: 10s
      timeout: 10s
      retries: 3

  kimai:
    image: kimai2/kimai:apache-latest-dev
    environment:
      - TRUSTED_HOSTS=localhost
      - ADMINMAIL=admin@kimai.local
      - ADMINPASS=changemeplease
      - DATABASE_URL=mysql://kimaiuser:kimaipassword@sqldb/kimai
      - TRUSTED_HOSTS=nginx,localhost,127.0.0.1
    ports:
      - 8001:8001
    volumes:
      - public:/opt/kimai/public
      # - var:/opt/kimai/var
      # - ./ldap.conf:/etc/openldap/ldap.conf:z
      # - ./ROOT-CA.pem:/etc/ssl/certs/ROOT-CA.pem:z
    restart: unless-stopped

  postfix:
    image: catatnight/postfix:latest
    environment:
      maildomain: neontribe.co.uk
      smtp_user: kimai:kimai
    restart: unless-stopped

  #autoupdate:
  #  image: kimai/kimai2
  #  volumes:
  #      - public:/public
  #      - ./bin/copy-public.sh:/copy-public.sh
  #  entrypoint: /copy-public.sh
  #  user: 0:0

volumes:
    var:
    public:

```

### fpm-prod

A production ready kimai server, fronted by a Nginx reverse proxy and a mysql databse.

```dockerfile
version: '3.5'
services:

  sqldb:
    image: mysql:5.7
    environment:
      - MYSQL_DATABASE=kimai
      - MYSQL_USER=kimaiuser
      - MYSQL_PASSWORD=kimaipassword
      - MYSQL_ROOT_PASSWORD=changemeplease
    #volumes: # Uncomment to persist data
      #- /var/lib/mysql
    command: --default-storage-engine innodb
    restart: unless-stopped
    healthcheck:
      test: mysqladmin -p$$MYSQL_ROOT_PASSWORD ping -h localhost
      interval: 20s
      start_period: 10s
      timeout: 10s
      retries: 3

  nginx:
    image: tobybatch/nginx-fpm-reverse-proxy
    ports:
      - 8001:80
    volumes:
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
    image: kimai2/kimai:fpm-latest-prod
    environment:
      - TRUSTED_HOSTS=localhost
      - ADMINMAIL=admin@kimai.local
      - ADMINPASS=changemeplease
      - DATABASE_URL=mysql://kimaiuser:kimaipassword@sqldb/kimai
      - TRUSTED_HOSTS=nginx,localhost,127.0.0.1
    volumes:
      - public:/opt/kimai/public
      # - var:/opt/kimai/var
      # - ./ldap.conf:/etc/openldap/ldap.conf:z
      # - ./ROOT-CA.pem:/etc/ssl/certs/ROOT-CA.pem:z
    restart: unless-stopped

  postfix:
    image: catatnight/postfix:latest
    environment:
      maildomain: neontribe.co.uk
      smtp_user: kimai:kimai
    restart: unless-stopped

  #autoupdate:
  #  image: kimai/kimai2
  #  volumes:
  #      - public:/public
  #      - ./bin/copy-public.sh:/copy-public.sh
  #  entrypoint: /copy-public.sh
  #  user: 0:0

volumes:
    var:
    public:

```
