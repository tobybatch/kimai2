## Installing
### Using apache-debian
- run container with named volume mount for `/opt/kimai/var`
> `docker run -p 8001:8001 --rm --name=Kimai2 -v kimai_var:/opt/kimai/var KIMAIIMAGE`
### Using fpm-alpine
- run compose file
> `docker-compose up -d`

## Upgrading Kimai version
### Using apache-debian
- stop your container
- run new version and mount you named `/opt/kimai/var` volume into container
### Using fpm-alpine
- stop all containers with compose
- change kimai image in compose file
- delete the kimai `source` volume (NOT THE `var`)  
  (this volume will only be used to share kimai source with the nginx webserver.  
  delete forces to recreate and use the new, updated kimai sources )
- restart your compose file