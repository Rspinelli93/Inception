#!/bin/bash

set -e

echo "[DEBUG] Preparing MariaDB..."

DB_PASSWORD=$(cat /run/secrets/db_password)
ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql


# Create MariaDB system files only on first start.
if [ ! -d "/var/lib/mysql/mysql" ]; then

    echo "[DEBUG] First start: initializing database..."

    mariadb-install-db \
        --user=mysql \
        --datadir=/var/lib/mysql

fi


# SQL executed automatically when MariaDB starts.
cat > /run/mysqld/init.sql <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%'
IDENTIFIED BY '${DB_PASSWORD}';

ALTER USER '${MYSQL_USER}'@'%'
IDENTIFIED BY '${DB_PASSWORD}';

GRANT ALL PRIVILEGES
ON \`${MYSQL_DATABASE}\`.*
TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

chown mysql:mysql /run/mysqld/init.sql
chmod 600 /run/mysqld/init.sql

echo "[DEBUG] Starting MariaDB..."

# MariaDB executes init.sql during startup and stays as PID 1.
exec mariadbd \
    --user=mysql \
    --console \
    --init-file=/run/mysqld/init.sql

#* LOGIC
# container starts 
#    ↓ read secrets 
#    ↓ database already exists?
# ├── no → initialize it
# └── yes → keep existing data 
#    ↓ start MariaDB

