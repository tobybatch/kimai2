# Local Overrides

Pretty much any kimai setting can be overrided.  Full project docs are [here](https://www.kimai.org/documentation/configurations.html) in the section Overwriting local configs.

To achieve this we need to create a local.yaml and mount it into the container at runtime.

e.g. Set the currency and location settings to be London rather than Berlin:

```yaml
kimai:
    defaults:
        customer:
            timezone: Europe/London
            country: GB
            currency: GBP
```

And we can mount that at runtime:

    docker run \
      -ti --rm --name kimai \
      -v $(pwd)/local.yaml:/opt/kimai/config/packages/local.yaml \
      -p 8001:8001 \
      kimai/kimai2:master

More detailed examples can be derived from the [docker-compose](docker-compose.md) examples.
