#!/bin/bash

DATABASE_URL="${SQL_PROTOCOL}://"
if [ ! -z "${SQL_USER}" ]; then
    DATABASE_URL="${DATABASE_URL}${SQL_USER}"
fi
if [ ! -z "${SQL_PASSWORD}" ]; then
    DATABASE_URL="${DATABASE_URL}:${SQL_PASSWORD}@"
fi
if [ ! -z "${SQL_HOST}" ]; then
    DATABASE_URL="${DATABASE_URL}${SQL_HOST}"
fi
export DATABASE_URL="${DATABASE_URL}/${SQL_DATABASE}"
echo "DATABASE_URL = ${DATABASE_URL}"

# If we are mysql wait for it.
if [[ "${DATABASE_URL}" == mysql* ]]; then
    echo Using Mysql DB
    until mysql -u ${SQL_USER} -p${SQL_PASSWORD} -h ${SQL_HOST} ${SQL_DATABASE} -e "show tables"; do
        >&2 echo "Mysql is unavailable - sleeping"
        sleep 5
    done
else
    echo Using non mysql DB
fi

# Set .env for CLI
echo "# Check /etc/apache2/sites-available/000-default.conf for env setting" > /opt/kimai/.env
cat <<EOF >> /opt/kimai/.env
DATABASE_PREFIX=${DATABASE_PREFIX}
MAILER_FROM=${MAILER_FROM}
APP_SECRET=${APP_SECRET}
DATABASE_URL=${DATABASE_URL}
MAILER_URL=${MAILER_URL}
EOF

# Set 000-default.conf for prod
sed -i "s/{DATABASE_PREFIX}/${DATABASE_PREFIX}" /etc/apache2/sites-available/000-default.conf
sed -i "s/{MAILER_FROM}/${MAILER_FROM}" /etc/apache2/sites-available/000-default.conf
sed -i "s/{APP_SECRET}/${APP_SECRET}" /etc/apache2/sites-available/000-default.conf
sed -i "s/{DATABASE_URL}/${DATABASE_URL}" /etc/apache2/sites-available/000-default.conf
sed -i "s/{MAILER_URL}/${MAILER_URL}" /etc/apache2/sites-available/000-default.conf

if [ "${TRUSTED_PROXIES}" != 'false' ]; then
    echo TRUSTED_PROXIES=${TRUSTED_PROXIES} >> /opt/kimai/.env
fi
if [ "${TRUSTED_HOSTS}" != 'false' ]; then
    echo TRUSTED_PROXIES=${TRUSTED_HOSTS} >> /opt/kimai/.env
fi

# If the schema does not exist then create it (and run the migrations)
TABLE_COUNT=$(/opt/kimai/bin/console doctrine:query:dql "Select u from App\Entity\User u")
STATUS=$?
if [ -z "$TABLE_COUNT" ]; then
    # We can't find the users table.  We'll usae this to guess we don't have a schema installed.
    # Is there a better way of doing this?
    /opt/kimai/bin/console -n doctrine:schema:create
    /opt/kimai/bin/console -n doctrine:migrations:version --add --all
fi

# If we have a start up/seed sql file run that.
for initfile in /var/tmp/init-sql/*; do

    if [ ${initfile: -4} == ".sh" ]; then
        sh $initfile

    elif [ ${initfile: -4} == ".dql" ]; then
        while IFS='' read -r line || [[ -n "$line" ]]; do
            echo $line
            /var/www/html/bin/console doctrine:query:dql "$line"
        done < $initfile

    elif [ ${initfile: -4} == ".sql" ]; then
        while IFS='' read -r line || [[ -n "$line" ]]; do
            echo $line
            /var/www/html/bin/console doctrine:query:sql "$line"
        done < $initfile
    fi
done

# Warm up the cache
/opt/kimai/bin/console cache:clear --env=prod
/opt/kimai/bin/console cache:warmup --env=prod

# Start listening
/usr/sbin/apache2ctl -D FOREGROUND
