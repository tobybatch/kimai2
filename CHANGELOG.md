# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

### [2.3.1](https://github.com/tobybatch/kimai2/compare/v2.3.0...v2.3.1) (2023-06-22)


### Features

* re-enable workflows ([b046420](https://github.com/tobybatch/kimai2/commits/b046420ce5e15d57bfb50e1950311708bf773c37))

## [2.3.0](https://github.com/tobybatch/kimai2/compare/v2.2.1...v2.3.0) (2023-05-25)


### Features

* enable v2 builds ([d6d11ad](https://github.com/tobybatch/kimai2/commits/d6d11ad40f7987b2e2a4e9147a3c47b4116c5a5f))
* enables opcache ([#452](https://github.com/tobybatch/kimai2/issues/452)) ([a6e14b4](https://github.com/tobybatch/kimai2/commits/a6e14b45270ade88974ba46a2cba759fb09a3e9f)), closes [#451](https://github.com/tobybatch/kimai2/issues/451)
* traefik compose example ([#479](https://github.com/tobybatch/kimai2/issues/479)) ([aaec0e5](https://github.com/tobybatch/kimai2/commits/aaec0e57dd1120b8f3b2a4528e4abc9c2d93abbc))


### Bug Fixes

* small tweaks for v2 ([c2d6e3b](https://github.com/tobybatch/kimai2/commits/c2d6e3b5794cc9c680561d41789388fc32c072fc))
* **assets:** Change create user command for new version ([#505](https://github.com/tobybatch/kimai2/issues/505)) ([41731a1](https://github.com/tobybatch/kimai2/commits/41731a19a4b19cbf72474355a7ecccf1e14e2d26))
* [#462](https://github.com/tobybatch/kimai2/issues/462) ([7212829](https://github.com/tobybatch/kimai2/commits/7212829d3dc8a3d0451cc4f70d99e13b49cd551a))
* [#495](https://github.com/tobybatch/kimai2/issues/495) and [#488](https://github.com/tobybatch/kimai2/issues/488) ([#496](https://github.com/tobybatch/kimai2/issues/496)) ([0fae66b](https://github.com/tobybatch/kimai2/commits/0fae66bb4ca5e0e73b244733d5591a85cac8e19c))
* added ENV COMPOSER_ALLOW_SUPERUSER=1 to allow LDAP build ([81a0166](https://github.com/tobybatch/kimai2/commits/81a01668169c8fc1b4ad5e9f0ee53f4e83aa1569))
* added swagger and phpmyadmin ([80655ff](https://github.com/tobybatch/kimai2/commits/80655ff3553ba2d313170686b444b78fb6d92f6b))
* build arg passthrough; add PHP & composer ver ([#478](https://github.com/tobybatch/kimai2/issues/478)) ([2afc8cb](https://github.com/tobybatch/kimai2/commits/2afc8cbd31b4b9769009577d8fc380a302840423))
* bump node version to 18 ([3f32d05](https://github.com/tobybatch/kimai2/commits/3f32d059bef88d92a7352933938302ff8a22651d))
* capped the build version at 1.x ([1d4e8ba](https://github.com/tobybatch/kimai2/commits/1d4e8ba7fc5fb82c04b405a9af06f9241c06362b))
* disable auto build on push ([#472](https://github.com/tobybatch/kimai2/issues/472)) ([b871f0e](https://github.com/tobybatch/kimai2/commits/b871f0e59fec5a5798fe15d5e44fe88e09b6c396))
* moved back to docker buildx ([a9219bd](https://github.com/tobybatch/kimai2/commits/a9219bdac152c4aac907177a725319e14afd0c4b))
* moved back to docker buildx ([62f1838](https://github.com/tobybatch/kimai2/commits/62f18388f5fe6f6efa44f698a849b03d795b23a8))
* push after build ([1cfbe9b](https://github.com/tobybatch/kimai2/commits/1cfbe9b0ae74f5ee6fed785834e27a307bc833f7))
* ready for v2 ([993e98e](https://github.com/tobybatch/kimai2/commits/993e98e628c7c7f8d76f091682655870908f1421))
* remove symfont cli ([#471](https://github.com/tobybatch/kimai2/issues/471)) ([160d797](https://github.com/tobybatch/kimai2/commits/160d797bb6ea67d632c86615b3a1efa47708533c))
* removed multi arch ([8f513f6](https://github.com/tobybatch/kimai2/commits/8f513f6d090fd38b72abe3b5a04bf7aa6240df11))
* removed tagging from multiarch build ([98e88c5](https://github.com/tobybatch/kimai2/commits/98e88c58a275ea789665c63185102d91b7a05cc5))
* restored cli logging for monolog ([470ecf0](https://github.com/tobybatch/kimai2/commits/470ecf07b80396af106d688c5c09e01fb63dbe53))
* try a different containerd src ([e79fcbc](https://github.com/tobybatch/kimai2/commits/e79fcbc3c2bd712cd21b5566c69b74b879872aa1))
* try a different containerd src ([e191dae](https://github.com/tobybatch/kimai2/commits/e191dae917cd7e5531e465c722c5b8dcef787213))
* wait to tag after building ([bdde499](https://github.com/tobybatch/kimai2/commits/bdde4992cdf672f0f394ad8f092e2ca6cce9980b))

### [2.2.1](https://github.com/tobybatch/kimai2/compare/v2.0.4...v2.2.1) (2022-10-20)

### [2.0.4](https://github.com/tobybatch/kimai2/compare/v2.2.0...v2.0.4) (2022-10-20)

### Features

* allow memory_limit to be set at runtime ([6934c36](https://github.com/tobybatch/kimai2/commits/6934c36588664a8d7659a225d399a1f3b14a7ebb))
* update docker action ([8bfcb69](https://github.com/tobybatch/kimai2/commits/8bfcb6918fb9c5dbedf4491c0d9c2c454edfd870))

### Bug Fixes

* added tags ([#326](https://github.com/tobybatch/kimai2/issues/326)) ([2d24f66](https://github.com/tobybatch/kimai2/commits/2d24f667a987cbd7459913ff327ebe5d757e73b1))
* apache base name ([150747d](https://github.com/tobybatch/kimai2/commits/150747da7445666c7537ff5e633cac4f3675e147))
* bad links in the examples file ([6e0ea6b](https://github.com/tobybatch/kimai2/commits/6e0ea6ba8078bdf2680a06b6a5d0decf0d9db798))
* corrected docs on build page ([9352609](https://github.com/tobybatch/kimai2/commits/935260940a4e08b7b4f937efb3bda8ada1d289bd))
* Docker Hub link in README ([26acc94](https://github.com/tobybatch/kimai2/commits/26acc945e1e0329cfcbf675754d0820364d10058))
* Docker Hub link in README ([c5fa08f](https://github.com/tobybatch/kimai2/commits/c5fa08fdab084fca7322472ee9f5d145b2f0bddb))
* Don't expose PHP version in response headers (prod only) ([#346](https://github.com/tobybatch/kimai2/issues/346)) ([1820d8e](https://github.com/tobybatch/kimai2/commits/1820d8e59dde3922f2899dc6ed141a55cc2bd2b7))
* roll up apache version ([acdb746](https://github.com/tobybatch/kimai2/commits/acdb74697cb75370422bfaf1df4b80b43e799e1f))
* target param corrected ([#353](https://github.com/tobybatch/kimai2/issues/353)) ([1806772](https://github.com/tobybatch/kimai2/commits/1806772f3fa16ce901255891ff574faa23836990))
* workflow ([#350](https://github.com/tobybatch/kimai2/issues/350)) ([25e5b5a](https://github.com/tobybatch/kimai2/commits/25e5b5ab8754f6133820c6e7c90cd27c2b1eb4ce))

### [2.0.3](https://github.com/tobybatch/kimai2/compare/v2.2.0...v2.0.3) (2021-09-30)

### Features

* add tzdata ([af9c60c](https://github.com/tobybatch/kimai2/commits/af9c60c27423668ab939da13a003aae891fa75d7))

### [2.0.2](https://github.com/tobybatch/kimai2/compare/v2.0.1...v2.0.2) (2021-05-14)

### 2.0.1 (2021-04-30)

### Features

* allow ingress annotations ([#244](https://github.com/tobybatch/kimai2/issues/244)) ([18751ac](https://github.com/tobybatch/kimai2/commits/18751acebf03b4ee56d631cebc587ab8b7bef997))

### Bug Fixes

* reinstated  file marker ([625dbd7](https://github.com/tobybatch/kimai2/commits/625dbd7a26dba0c0d3005ca142be91b08a9c2a23))
* updated tag names in readme ([#243](https://github.com/tobybatch/kimai2/issues/243)) ([f6a6cac](https://github.com/tobybatch/kimai2/commits/f6a6cac3554d4ecd5fb1e2a1a30fec02ae1cd649))
