#!/bin/bash

echo "DATABASE_URL = ${DATABASE_URL}"

# If we are mysql wait for it.
if [[ "${DATABASE_URL}" == mysql* ]]; then
    echo Using Mysql DB
    SQL_PROTOCOL=$(/url_parse.php $DATABASE_URL scheme)
    SQL_USER=$(/url_parse.php $DATABASE_URL user)
    SQL_PASSWORD=$(/url_parse.php $DATABASE_URL pass)
    SQL_HOST=$(/url_parse.php $DATABASE_URL host)
    SQL_PORT=$(/url_parse.php $DATABASE_URL port)
    SQL_DATABASE=$(/url_parse.php $DATABASE_URL path)

    if [ ! -z "${SQL_PORT}" ]; then
      PORT="-P ${SQL_PORT}"
      echo "  port:  $PORT"
    fi

    until mysql -u ${SQL_USER} -p${SQL_PASSWORD} -h ${SQL_HOST} ${PORT} ${SQL_DATABASE} -e "show tables"; do
        echo "mysql -u ${SQL_USER} -p${SQL_PASSWORD} -h ${SQL_HOST} ${PORT} ${SQL_DATABASE}"
        >&2 echo "Mysql is unavailable - sleeping"
        sleep 5
    done
else
    echo Using non mysql DB
fi

# If the schema does not exist then create it (and run the migrations)
/opt/kimai/bin/console -n kimai:install

# If we have a start up/seed sql file run that.
for initfile in /var/tmp/init-sql/*; do

    if [ ${initfile: -4} == ".sh" ]; then
        sh $initfile

    elif [ ${initfile: -4} == ".dql" ]; then
        while IFS='' read -r line || [[ -n "$line" ]]; do
            echo $line
            /opt/kimai/bin/console doctrine:query:dql "$line"
        done < $initfile

    elif [ ${initfile: -4} == ".sql" ]; then
        while IFS='' read -r line || [[ -n "$line" ]]; do
            echo $line
            /opt/kimai/bin/console doctrine:query:sql "$line"
        done < $initfile
    fi
done

# Warm up the cache
/opt/kimai/bin/console cache:clear --env=prod
/opt/kimai/bin/console cache:warmup --env=prod

if [ ! -z "$ADMINPASS" ] && [ ! -a "$ADMINMAIL"]; then
  /opt/kimai/bin/console kimai:create-user superadmin $ADMINMAIL ROLE_SUPER_ADMIN $ADMINPASS
fi

touch /tmp/started
# Start listening
if [ -e /use_apache ]; then 
  /usr/sbin/apache2ctl -D FOREGROUND
elif [ -e /use_fpm ]; then 
  php-fpm
else
  echo "Error, unknown server type"
fi
