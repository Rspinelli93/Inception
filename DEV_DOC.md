# Developer Documentation

## Requirements

* Linux VM
* Docker
* Docker Compose
* Make

## Architecture

```text
Browser
   |
 HTTPS
   |
   v
NGINX
   |
 FastCGI
   |
   v
WordPress / PHP-FPM
   |
 MariaDB SQL
   |
   v
MariaDB
```

NGINX is the only public entry point and listens on port `443`.

NGINX forwards PHP requests to WordPress using FastCGI:

```text
wordpress:9000
```

WordPress connects to MariaDB using:

```text
mariadb:3306
```

WordPress and MariaDB use persistent volumes.

## Full cleanup

```bash
make fclean
```

**WARNING:** This removes persistent volumes.

## Containers

```bash
make ps
```

## Images

```bash
make images
```

## Volumes

```bash
make volumes
```

Persistent data is stored in:

```text
/home/<login>/data/mariadb
/home/<login>/data/wordpress
```

## Network

All containers use the `inception` Docker network.

Docker service names act as hostnames:

```text
nginx -> wordpress:9000
wordpress -> mariadb:3306
```

## MariaDB

Open the database client:

```bash
make db
```

## Container Shells

MariaDB:

```bash
make shell-db
```

WordPress:

```bash
make shell-wp
```

NGINX:

```bash
make shell-nginx
```

---

# Architecture You Need to Know for Defense

```text
                    BROWSER
                       |
                   HTTPS :443
                       |
                       v
                 +-----------+
                 |   NGINX   |
                 +-----+-----+
                       |
                    FastCGI
                       |
                 wordpress:9000
                       |
                       v
               +---------------+
               |   WORDPRESS   |
               |    PHP-FPM    |
               +-------+-------+
                       |
                  MariaDB SQL
                       |
                  mariadb:3306
                       |
                       v
                 +-----------+
                 |  MARIADB  |
                 +-----------+
```

## Persistence

```text
wordpress
    |
    v
/home/<login>/data/wordpress


mariadb
    |
    v
/home/<login>/data/mariadb
```

## Secrets

```text
secret file
    |
    v
Docker Compose
    |
    v
/run/secrets/<name>
    |
    v
init.sh reads password
```

