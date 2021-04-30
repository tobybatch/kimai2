# Kimai Dockers

We provide a set of docker images for the [Kimai v2](https://github.com/kevinpapst/kimai2) project.

The built images are available from [Kimai v2](https://hub.docker.com/repository/docker/kimai/kimai2) at Docker Hub.

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
            kimai/kimai2:apache
 
 1. Add a user, open a new terminal and:
 
        docker exec -ti kimai-test \
            /opt/kimai/bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN
    
You can now hit the kimai instance on http://localhost:8001

This docker transient and will disappear when you stop the containers.

    docker stop kimai-mysql-testing kimai-test

## Using docker-compose

This will run the latest prod version using FPM with an nginx reverse proxy

```docker-compose
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

  kimai: # This is the latest FPM image of kimai
    image: kimai/kimai2:latest
    environment:
      - APP_ENV=prod
      - TRUSTED_HOSTS=localhost
      - ADMINMAIL=admin@kimai.local
      - ADMINPASS=changemeplease
      - DATABASE_URL=mysql://kimaiuser:kimaipassword@sqldb:3306/kimai
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

volumes:
    var:
    public:
```

## Documentation

[https://tobybatch.github.io/kimai2/](https://tobybatch.github.io/kimai2/)
