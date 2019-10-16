#!/bin/bash

echo $KIMAI


function waitForDB() {
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

  # # installed - but false version
  # elif ! [ $(cat /opt/kimai/installed) == $KIMAI ]; then
  #   echo "other Kimai2 version detected - try to migrate"
  #   echo $KIMAI
  #   cat /opt/kimai/installed
  #   # todo fetch new kimai source GIT
  #   cd /opt/kimai
  #   #git fetch --tags
  #   #git checkout $KIMAI
  #   composer install --working-dir=/opt/kimai --optimize-autoloader
  #   bin/console cache:clear --env=prod
  #   bin/console cache:warmup --env=prod
  #   bin/console doctrine:migrations:migrate
  #   echo $KIMAI > /opt/kimai/installed
  fi
  echo "Kimai2 ready"
}

function runServer() {
  if [ -e /use_apache ]; then 
    exec /usr/sbin/apache2ctl -D FOREGROUND
  elif [ -e /use_fpm ]; then 
    exec php-fpm
  else
    echo "Error, unknown server type"
  fi
}


###########################
# SQL stuff
###########################

# Parse sql connection data
# todo: port is not used atm
DB_TYPE=$(awk -F '[/:@]' '{print $1}' <<< $DATABASE_URL)
DB_USER=$(awk -F '[/:@]' '{print $4}' <<< $DATABASE_URL)
DB_PASS=$(awk -F '[/:@]' '{print $5}' <<< $DATABASE_URL)
DB_HOST=$(awk -F '[/:@]' '{print $6}' <<< $DATABASE_URL)
DB_BASE=$(awk -F '[/:@]' '{print $7}' <<< $DATABASE_URL)

waitForDB
handleStartup
runServer

exit


