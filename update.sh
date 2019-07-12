#!/bin/bash

STACKS="apache-debian fpm-debian fpm-alpine"
WORKDIR=$(dirname $0)

for STACK in $STACKS; do
  mkdir -p build/$STACK
done

cp $WORKDIR/assets/Dockerfile.apache $WORKDIR/build/apache-debian/Dockerfile
cp $WORKDIR/assets/000-default.conf  $WORKDIR/build/apache-debian/000-default.conf
cp $WORKDIR/assets/startup.sh        $WORKDIR/build/apache-debian/startup.sh
cp $WORKDIR/assets/url_parse.php     $WORKDIR/build/apache-debian/url_parse.php

sed -e "s/DISTRO/alpine/g" $WORKDIR/assets/Dockerfile.fpm > $WORKDIR/build/fpm-alpine/Dockerfile
cp $WORKDIR/assets/000-default.conf  $WORKDIR/build/fpm-alpine/000-default.conf
cp $WORKDIR/assets/startup.sh        $WORKDIR/build/fpm-alpine/startup.sh
cp $WORKDIR/assets/nginx-startup.sh  $WORKDIR/build/fpm-alpine/nginx-startup.sh
cp $WORKDIR/assets/url_parse.php     $WORKDIR/build/fpm-alpine/url_parse.php

sed -e "s/DISTRO/debian/g" $WORKDIR/assets/Dockerfile.fpm > $WORKDIR/build/fpm-debian/Dockerfile
cp $WORKDIR/assets/000-default.conf  $WORKDIR/build/fpm-debian/000-default.conf
cp $WORKDIR/assets/startup.sh        $WORKDIR/build/fpm-debian/startup.sh
cp $WORKDIR/assets/nginx-startup.sh  $WORKDIR/build/fpm-debian/nginx-startup.sh
cp $WORKDIR/assets/url_parse.php     $WORKDIR/build/fpm-debian/url_parse.php


