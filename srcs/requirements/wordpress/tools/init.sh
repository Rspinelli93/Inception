#!/bin/bash

set -e

echo "[DEBUG] Preparing WordPress..."

# Read passwords supplied through Docker secrets.
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

mkdir -p /run/php
mkdir -p /var/www/html

# Copy WordPress only if the persistent volume is empty.
if [ ! -f /var/www/html/wp-load.php ]; then
    cp -a /usr/src/wordpress/. /var/www/html/
fi

cd /var/www/html

echo "[DEBUG] Waiting for MariaDB..."

DB_READY=0

# Try for about 60 seconds instead of waiting forever.
for i in $(seq 1 30); do
    if mariadb \
        -h mariadb \
        -u "${MYSQL_USER}" \
        -p"${DB_PASSWORD}" \
        "${MYSQL_DATABASE}" \
        -e "SELECT 1;" >/dev/null 2>&1
    then
        DB_READY=1
        break
    fi

    sleep 2
done

if [ "$DB_READY" -ne 1 ]; then
    echo "ERROR: MariaDB is not available."
    exit 1
fi

# Create wp-config.php only on first setup.
if [ ! -f wp-config.php ]; then
    wp config create \
        --allow-root \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="mariadb:3306"
fi

# Install WordPress only if it is not already installed in MariaDB.
if ! wp core is-installed --allow-root; then
    wp core install \
        --allow-root \
        --url="https://${DOMAIN_NAME}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email

    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --allow-root \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author
fi

chown -R www-data:www-data /var/www/html

echo "[DEBUG] Starting PHP-FPM..."

# -F keeps PHP-FPM in the foreground as PID 1.
exec php-fpm8.2 -F

# DIAGRAMA
# container starts
#       ↓
# read secrets
#       ↓
# copy WordPress files if needed
#       ↓
# wait for MariaDB
#       ↓
# create wp-config.php
#       ↓
# install WordPress if needed
#       ↓
# start PHP-FPM
