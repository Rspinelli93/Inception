# Docker Compose lifecycle

### Validate and print the final Compose config (aka YAML)
```bash
docker compose config
```
---------------------------------

## BUILDING IMAGES

### Build all images
```bash
docker compose build
```
### Build a particular one (this can be done after modifiny only one)
```bash
docker compose build nginx
```
### Build without using cache
```bash
docker compose build --no-cache
```
---------------------------------

## CREATE && START CONTAINERS

### Create and start all services in the front
```bash
docker compose up
```
### Create and start all services in the back
-d = detached mode.
```bash
docker compose up -d
```
### Rebuild images, then create/start containers.
```bash
docker compose up -d --build
```
### Start only one service.
```bash
docker compose up -d nginx
```
---------------------

### Start previously stopped Compose containers
```bash
docker compose start
```
---------------------------------

## STOP CONTAINERS

### Stop running Compose containers without removing them
```bash
docker compose stop
```
### Stop one service
```bash
docker compose stop nginx
```
### Restart all Compose services
```bash
docker compose restart
```
### Restart one service
```bash
docker compose restart nginx
```
---------------------------------

## CLEANUP

### Stop and remove Compose containers and the project network
```bash
docker compose down
```
### Stop/remove containers, networks, AND named volumes
WARNING: persistent data is deleted
```bash
docker compose down -v
```
---------------------------------

## INSPECT CONTAINERS

#### Show running Compose services.
```bash
docker compose ps
```
#### Show all Compose containers, including stopped ones.
```bash
docker compose ps -a
```
#### Show logs from all services.
```bash
docker compose logs
```
#### Show logs from one service.
```bash
docker compose logs nginx
```
#### Follow logs live.
-f = follow.
```bash
docker compose logs -f
```
#### Follow one service's logs.
```bash
docker compose logs -f mariadb
```

## SHELL

### Run a shell inside a running service container.
```bash
docker compose exec nginx bash
```
### For minimal images that only have sh:
```bash
docker compose exec nginx sh
```
### Run a command directly inside a service container.
```bash
docker compose exec nginx nginx -t
```
### Run a command inside MariaDB container.
```bash
docker compose exec mariadb mysql
```

-------------------------
# IMAGES

### Show the images used by the current Compose project

```bash
docker compose images
```

### Show all Docker images on your computer

```bash
docker images
or
docker image ls
```

### Build all Compose images

```bash
docker compose build
#Use this after changing Dockerfiles.
```
### Build only one image

```bash
docker compose build mariadb
```

### Inspect an image

```bash
docker image inspect mariadb
```

### Show how an image was built layer by layer

```bash
docker history mariadb
```

### Remove one image

```bash
docker rmi mariadb
```

### Force-remove one image

```bash
docker rmi -f mariadb
# -f = force.
```

### Remove unused images

```bash
docker image prune
```

### Remove more unused images

```bash
docker image prune -a
-a = all unused images, not only the small leftover ones.
```

### Typical image rebuild

```bash
docker compose up -d --build mariadb
```
---------------------------------

# VOLUMES

### Show volumes used by the current Compose project

```bash
docker compose volumes
```
### Show all Docker volumes on your computer

```bash
docker volume ls
```

### Inspect a volume

```bash
docker volume inspect inception_mariadb-data
```

### Create a volume manually

```bash
docker volume create test-volume
```

### Remove one volume

```bash
docker volume rm inception_mariadb-data
# WARNING: if this is your MariaDB volume, your database data will be lost.
```

### Remove unused volumes

```bash
docker volume prune
```

### Stop the Compose project but KEEP volumes

```bash
docker compose down
```

### Stop the Compose project and DELETE volumes
```bash
docker compose down -v
# -v = remove volumes.
# WARNING: this deletes persistent data.
```

### Check if your MariaDB volume exists

```bash
docker volume ls
```

### Check what container is using a volume

First inspect the volume:
```bash
docker volume inspect inception_mariadb-data
```

Then inspect containers:
```bash
docker ps -a
```

### Remove containers before removing a volume

```bash
docker compose down --remove-orphans
docker volume rm inception_mariadb-data
```

If there is still an old container:
```bash
docker ps -a
```
Remove it:
```bash
docker rm -f CONTAINER_NAME
```

### Typical volume persistence test

Start MariaDB:
```bash
docker compose up -d mariadb
```

Create some data inside MariaDB.

Then:
```bash
docker compose down
```

Start again:
```bash
docker compose up -d mariadb
```

If the data is still there, the volume is working.

### Typical full cleanup during practice

Remove containers, network, and Compose volumes:
```bash
docker compose down -v --remove-orphans
```

Check:
```bash
docker ps -a
docker volume ls
```

### Important difference

```bash
docker compose down
# removes containers and networks
```

```bash
docker compose down -v
# removes containers, networks and volumes
```

If you also want to remove images, you remove them separately:
```bash
docker rmi nginx wordpress mariadb
```

------------------------

# Docker, not Compose

### Show running containers.
```bash
docker ps
```
### Show all containers, including stopped/failed/created.
```bash
docker ps -a
```
### Show detailed container configuration.
```bash
docker inspect nginx
```
### Show container processes.
```bash
docker top nginx
```
### Show container resource usage.
```bash
docker stats
```
### Show published ports.
```bash
docker port nginx
```
### Show container logs.
```bash
docker logs nginx
```
### Follow logs.
```bash
docker logs -f nginx
```
## Remove containers manually

### Stop a running container.
```bash
docker stop nginx
```
### Remove a stopped container.
```bash
docker rm nginx
```
### Force-stop and remove a container.
```bash
docker rm -f nginx
```
### Remove all stopped containers.
```bash
docker container prune
```
