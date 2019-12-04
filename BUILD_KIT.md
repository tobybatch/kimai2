# Build all images

```bash
export KIMAI=1.5
export TZ=Europe/London
export DOCKER_BUILDKIT=1

for _KIMAI in $KIMAI master; do
    for VER in dev prod; do
        for BASE in apache-debian fpm-alpine; do
            docker build -t kimai/kimai2:${BASE}-${_KIMAI}-${VER} --build-arg BASE=${BASE} --build-arg VER=${VER} .
        done
    done
done
```

## Run the test compose

    export KIMAI=1.5
    docker-compose 