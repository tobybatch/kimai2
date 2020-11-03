#!/bin/bash

echo $KIMAI

function waitForDB() {
  # Parse sql connection data
  if [ ! -z "$DATABASE_URL" ]; then
    DB_TYPE=$(awk -F '[/:@]' '{print $1}' <<< $DATABASE_URL)
    DB_USER=$(awk -F '[/:@]' '{print $4}' <<< $DATABASE_URL)
    DB_PASS=$(awk -F '[/:@]' '{print $5}' <<< $DATABASE_URL)
    DB_HOST=$(awk -F '[/:@]' '{print $6}' <<< $DATABASE_URL)
    DB_PORT=$(awk -F '[/:@]' '{print $7}' <<< $DATABASE_URL)
    DB_BASE=$(awk -F '[/?]' '{print $4}' <<< $DATABASE_URL)
  else
    DB_TYPE=${DB_TYPE:mysql}
    if [ "$DB_TYPE" == "mysql" ]; then
      export DATABASE_URL="${DB_TYPE}://${DB_USER:=kimai}:${DB_PASS:=kimai}@${DB_HOST:=sqldb}:${DB_PORT:=3306}/${DB_BASE:=kimai}"
    elif [ "$DB_TYPE" == "sqlite" ]; then
      export DATABASE_URL="${DB_TYPE}://${DB_BASE:=%kernel.project_dir%/var/data/kimai.sqlite}"
    else
      echo "Unkown database type, cannot proceed.  Expected one of: mysql, sqlite. Received: [$DB_TYPE]"
      exit 1
    fi
  fi

  re='^[0-9]+$'
  if ! [[ $DB_PORT =~ $re ]] ; then
     DB_PORT=3306
  fi

  # If we use mysql wait until its online
  if [[ $DB_TYPE == "mysql" ]]; then
      echo "Using Mysql DB"
      echo "Wait for db connection ..."
      until php -r "new PDO(\"mysql:host=$DB_HOST;dbname=$DB_BASE;port=$DB_PORT\", \"$DB_USER\", \"$DB_PASS\");" &> /dev/null; do
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
  fi
  # Add this here so it's always available, it would be lost between conatiner restarts.
  export KIMAI=$(/opt/kimai/bin/console kimai:version --short)
  echo $KIMAI > /opt/kimai/installed
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
