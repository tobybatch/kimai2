#!/bin/bash -x

# shellcheck disable=SC2155
export KIMAI=$(/opt/kimai/bin/console kimai:version --short)
echo "***********************************************"
echo "STARTING KIMAI VERSION ${KIMAI} in ${APP_ENV}"
echo "***********************************************"


function config() {
  # set mem limits and copy in custom logger config
  if [ -z "$memory_limit" ]; then
    memory_limit=256
  fi

  if [ "${APP_ENV}" == "prod" ]; then
    sed "s/128M/${memory_limit}M/g" /usr/local/etc/php/php.ini-production > /usr/local/etc/php/php.ini
    if [ "${KIMAI:0:1}" -lt "2" ]; then
      cp /assets/monolog-prod.yaml /opt/kimai/config/packages/monolog.yaml
    else
      cp /assets/monolog.yaml /opt/kimai/config/packages/monolog.yaml
    fi
  else
    sed "s/128M/${memory_limit}M/g" /usr/local/etc/php/php.ini-development > /usr/local/etc/php/php.ini
    if [ "${KIMAI:0:1}" -lt "2" ]; then
      cp /assets/monolog-dev.yaml /opt/kimai/config/packages/monolog.yaml
    else
      cp /assets/monolog.yaml /opt/kimai/config/packages/monolog.yaml
    fi
  fi
  
  if [ -z "$USER_ID" ]; then
    USER_ID=www-data
  fi
  if [ -z "$GROUP_ID" ]; then
    GROUP_ID=www-data
  fi
  chown -R $USER_ID:$GROUP_ID /opt/kimai/var
}

config
# if user doesn't exist
adduser --no-create-home --disabled-password -u $USER_ID -g $GROUP_ID kimai-www
su kimai-www -s /service.sh
exit
