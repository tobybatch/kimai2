# Examples

Listed here are example set ups for running the image(s). If you'd like to contribute a new one them please raise a PR for this page.

 * [Apache dev](../compose/docker-compose.apache.dev.yml)
 * [Apache prod](../compose/docker-compose.apache.prod.yml)
 * [FPM dev](../compose/docker-compose.fpm.dev.yml)
 * [FPM prod](../compose/docker-compose.fpm.prod.yml)

None of these images persist the DB between restarts, you will need to add a volume to do that:

    volumes:
      - mysql:/var/lib/mysql

See the [docker-compose.yml](../docker-compose.yml) in the root of the repo.
