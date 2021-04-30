# Kimai Dockers

We provide a set of docker images for the [Kimai v2](https://github.com/kevinpapst/kimai2) project.

The built images are available from [Kimai v2](https://hub.docker.com/repository/docker/kimai/kimai2) at Docker Hub.

## Deving and Contributing

We use commit linting to generate commits that we can auto generate changelogs from. To set these up you will need node/nvm installed:

```bash
nvm use
npm install
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

## Quick start

Run the latest production build:

 1. Start a DB
 
        docker run --rm --name kimai-mysql-testing \
            -e MYSQL_DATABASE=kimai \
            -e MYSQL_USER=kimai \
            -e MYSQL_PASSWORD=kimai \
            -e MYSQL_ROOT_PASSWORD=kimai \
            -p 3399:3306 -d mysql
        
 1. Start Kimai 
   
        docker run --rm --name kimai-test \
            -ti \
            -p 8001:8001 \
            -e DATABASE_URL=mysql://kimai:kimai@${HOSTNAME}:3306/kimai \
            kimai/kimai2:apache-latest
 
 1. Add a user, open a new terminal and:
 
        docker exec -ti kimai-test \
            /opt/kimai/bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN
    
You can now hit the kimai instance on http://localhost:8001

This docker transient and will disappear when you stop the containers.

    docker stop kimai-mysql-testing kimai-test

## Using docker-compose

This will run the latest prod version using FPM with an nginx reverse proxy

See the [docker-compose.yml](docker-compose.yml) in the root of this repo.

## Documentation

[https://tobybatch.github.io/kimai2/](https://tobybatch.github.io/kimai2/)
