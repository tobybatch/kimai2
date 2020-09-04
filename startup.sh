#!/bin/bash

echo $KIMAI

function waitForDB() {
  # Parse sql connection data
  # todo: port is not used atm
  DB_TYPE=$(awk -F '[/:@]' '{print $1}' <<< $DATABASE_URL)
  DB_USER=$(awk -F '[/:@]' '{print $4}' <<< $DATABASE_URL)
  DB_PASS=$(awk -F '[/:@]' '{print $5}' <<< $DATABASE_URL)
  DB_HOST=$(awk -F '[/:@]' '{print $6}' <<< $DATABASE_URL)
  DB_BASE=$(awk -F '[/?]' '{print $4}' <<< $DATABASE_URL)

  # If we use mysql wait until its online
  if [[ $DB_TYPE == "mysql" ]]; then
      echo "Using Mysql DB"
      echo "Wait for db connection ..."
      until php -r "new PDO(\"mysql:host=$DB_HOST;dbname=$DB_BASE\", \"$DB_USER\", \"$DB_PASS\");" &> /dev/null; do
          sleep 3
      done
      echo "Connection established"
  else
      echo "Using non mysql DB"
  fi
}

function handleStartup() {
  # first start?
  if ! [ -e /opt/kimai/installed ]; then 
    echo "first run - install kimai"
    /opt/kimai/bin/console -n kimai:install
    if [ ! -z "$ADMINPASS" ] && [ ! -a "$ADMINMAIL" ]; then
      /opt/kimai/bin/console kimai:create-user superadmin $ADMINMAIL ROLE_SUPER_ADMIN $ADMINPASS
    fi
    echo $KIMAI > /opt/kimai/installed
  fi
  echo "Kimai2 ready"
}

function runServer() {
  /opt/kimai/bin/console kimai:reload --env=$APP_ENV
  if [ -e /use_apache ]; then 
    /usr/sbin/apache2ctl -D FOREGROUND
  elif [ -e /use_fpm ]; then 
    exec php-fpm
  else
    echo "Error, unknown server type"
  fi
}

waitForDB
handleStartup
runServer
exit
