# Troubleshooting

## NGINX and proxying

While outside the direct responsibility of this project we get a lot of issues reported that relate to proxying with NGINX into the FPM container.

Note that you will need to set the name of your NGINX container to be in the list of TRUSTED_HOSTS when you start the Kimai container.

## ARM support

We don't build ARM images at the moment. We use git hub actions to auto build releases and I can get them to build as multi arch images. The images build and run fine, but you'll need to build them yourself. See [Building it yourself](https://tobybatch.github.io/kimai2/build.html#building-the-kimai-docker) on how to do that.

If you fancy trying to fix the multi arch build, I have an on going attempt to do that in the branch `add-buildx-support` using `buildx`

## Permissions

If you are mounting the code base into the container (`-v $PWD/kimai:/opt/kimai`) then you will need to fix the permissions on the var folder.

```bash
docker exec --user root CONTAINER_NAME chown -R www-data:www-data /opt/kimai/var
```

or

```bash
docker-compose --user root exec CONTAINER_NAME chown -R www-data:www-data /opt/kimai/var
```

## 500 Server errors

Around nine out of ten of the bugs raised are related to the TRUSTED_HOSTS value.  If you get a 500 then check that the `TRUSTED_HOSTS` environment variable is set to either your hostname or the hostname of your proxy server (nginx etc).  In the docker-compose environment that is the container name of the nginx container.

## Older version

While we do backport bug fixes we only thoroughly test them against the latest release of Kimai.  We keep the older tags available for those who do not wish to upgrade, but if you encounter a bug then first retest after pulling the latest tag
before raising an issue.
