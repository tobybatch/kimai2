# Dev Instances

Run a throw away instance of Kimai for evaluation or testing.

This runs against a sqlite database inside the container using the built in Apache/mod_php server.

When stopped all trace of the docker will disappear.

If you run the lines below you can hit kimai at `http://localhost:8001` and log in with `admin` / `changemeplease`

The test users listed in [the develop section](https://www.kimai.org/documentation/installation.html) also exist.

```bash
docker run --rm -ti -p 8001:8001 --name kimai2 kimai/kimai2:latest
docker exec kimai2 rm /opt/kimai/var/data/kimai.sqlite
docker exec kimai2 /opt/kimai/bin/console kimai:reset-dev
docker exec kimai2 /opt/kimai/bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN changemeplease
```
