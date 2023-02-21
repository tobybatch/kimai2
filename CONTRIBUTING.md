# Contributing

This is an open source project we welcome any support that you want to give. Just fork the repo and raise a PR.

## Pull request rules

We use the [conventional-changelog](https://github.com/conventional-changelog/commitlint) package to generate the changelog. This uses commit lint rules. To enforce these rules for you run the following:

* Install nvm[...](https://duckduckgo.com/?q=nodejs+install+nvm&t=canonical&ia=web)
* `nvm use`
* `npm install`

This should install the git hooks to check your commits are in the correct format.

## Manual build

You can build the Image for local testing like this:

```bash
docker build --tag kimai2 \
    --no-cache \
    --build-arg PHP_VER=8.1 \
    --build-arg COMPOSER_VER=latest \
    --build-arg KIMAI=main \
    --build-arg TIMEZONE=Europe/Berlin \
    --build-arg BASE=fpm .
```
