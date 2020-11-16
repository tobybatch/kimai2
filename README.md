# Kimai Dockers

We provide a set of docker images for the [Kimai v2](https://github.com/kevinpapst/kimai2) project.

## Quick start

Run the latest build against tbe master branch of the Kimai repo using a bundled DB. **This is not suitable for production use**:

    docker run --rm -ti -p 8001:8001 --name kimai kimai/kimai2:latest-dev

Create an admin user in the new running docker:

    docker exec kimai /opt/kimai/bin/console kimai:create-user admin admin@example.com ROLE_SUPER_ADMIN

This docker transient and will disappear when you stop the container.

## Documentation

[https://tobybatch.github.io/kimai2/](https://tobybatch.github.io/kimai2/)

## Helm chart for Kubernetes Deployment

In order to allow an easy deployment on Kubernetes, there is also a Helm chart (https://helm.sh) available. The chart allows a parameterized deployment of Kimai on Kubernetes, using the Docker images also used for the standard dockr deployment. Since Kubernetes aims at a production use case, the Helm chart only allows the deployment with Apache and MySQL. More informartion about the chart and the configuration options are available in the [README](helm/README.md).
