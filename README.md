# Kimai Dockers

We provide a set of docker images for the [Kimai v2](https://github.com/kevinpapst/kimai2) project.

## Quick start

Run the latest released version of Kimai in production mode using a bundled sqlite DB:

    docker run --rm -ti -p 8001:8001 --name kimai2 kimai/kimai2

Create an admin user in the new running docker:

    docker exec kimai2 /opt/kimai/bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN

This docker transient and will disappear when you stop the container.

## Documentaion

 * Starting a dev instance
 * Using docker-compose
 * All runtime arguments
 * Building it yourself
   * Build arguments
 * Troubleshooting
   * NGINX and proxying
   * Fixing permissions
   * 500 Server errors
   * Older versions
