## Installing
### Using debian-apache
- run container with named volume mount
### Using fpm-alpine
- run compose file

## Upgrading Kimai version
### Using debian-apache
- stop your container
- run new version and mount you named `var` volume into container
### Using fpm-alpine
- stop all containers with compose
- change kimai image
- delete the kimai `data` volume (NOT THE `var`)
- restart your compose