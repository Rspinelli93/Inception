*This project has been created as part of the 42 curriculum by rspinell.*

# Inception

## Description

Inception builds a small infrastructure using Docker Compose.

It contains:

* NGINX with TLS
* WordPress with PHP-FPM
* MariaDB

Each service is built using its own Dockerfile.

NGINX is the public entry point.

WordPress communicates with MariaDB through a private Docker network.

WordPress and MariaDB data are stored persistently.

## Instructions

Create the local `.env` and secret files first.

Build and start:

```bash
make
```

Check services:

```bash
make ps
```

Stop:

```bash
make down
```

Rebuild:

```bash
make re
```

Website:

```text
https://<login>.42.fr
```

## Resources

Resources used:

* Docker documentation
* Docker Compose documentation
* NGINX documentation
* WordPress documentation
* MariaDB documentation
* PHP documentation

AI was used to explain concepts, review configurations, and assist with debugging. Suggestions were reviewed and studied before being used.

