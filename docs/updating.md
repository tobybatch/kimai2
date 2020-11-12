# Upgrading

BACK UP EVERYTHING. The database, the mounted volumes, everything. Please. Pretty please.

While this process (almost) always works there can be errors and we really don't want you to loose any data.

## The apache image

Just change the tag name and restart the image.

## The fpm image

The FPM image will need to be upgraded with a manual step. Because the FPM image will have a HTTP proxy (normally nginx) container serving the static assets the `public` directory is mounted into that nginx container. This is done via volumes:

```yaml
version: '3.5'
services:
    kimai:
        image: kimai/kimai2
        ...
        volumes:
            - public:/opt/kimai/public
        ...
    nginx:
        ...
        volumes:
            - public:/opt/kimai/public:ro
    ...
```

When the kimai image is updated and the container is restarted any new assets in the public directory are never included. These will be things like CSS files, images and especially version specific javascript code! To fix this you need to copy the newer files from a fresh image over the top.

```bash
me@myhost $ docker run --rm -ti -v kimai_public:/public --entrypoint /bin/bash kimai/kimai2
#                                  ^^^^^^^^^^^^ -> Where this is the name of your public volume
bash-5.0$ cp -r /opt/kimai/public /
bash-5.0$ exit
me@myhost $
```

And now you'll need to tell the running kimai to update it's assets:

```bash
me@myhost $ docker-compose exec kimai /opt/kimai/bin/console assets:install
```

That should do it.

### Automated upgrade

If you have backed up everything you can use the automated update image that will do the work for you.

Add this to the services section of your docker-compose:

```yaml
autoupdate:
    image: kimai/kimai2
    volumes:
        - public:/public
        - ./bin/copy-public.sh:/copy-public.sh
    entrypoint: /copy-public.sh
```

You'll still need to tell the running kimai to update it's assets:

```bash
me@myhost $ docker-compose exec kimai /opt/kimai/bin/console assets:install
```
