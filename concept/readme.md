## Installing
### Using debian-apache
- run container with named volume mount for `/opt/kimai/var`
### Using fpm-alpine
- run compose file

## Upgrading Kimai version
### Using debian-apache
- stop your container
- run new version and mount you named `/opt/kimai/var` volume into container
### Using fpm-alpine
- stop all containers with compose
- change kimai image
- delete the kimai `source` volume (NOT THE `var`)
- restart your compose file