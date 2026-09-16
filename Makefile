include srcs/.env
export

# Compose file and environment file used by every target.
COMPOSE = HOST_USER=$(USER) docker compose -f srcs/docker-compose.yml --env-file srcs/.env

all: up

host:
	@grep -q "$(DOMAIN_NAME)" /etc/hosts || \
		echo "127.0.0.1 $(DOMAIN_NAME)" | sudo tee -a /etc/hosts

# Create host directories, build images and start containers.
up: host
	mkdir -p /home/$(USER)/data/mariadb
	mkdir -p /home/$(USER)/data/wordpress
	$(COMPOSE) up -d --build --force-recreate

# Build all images.
build:
	$(COMPOSE) build

# Start already-created containers.
start:
	$(COMPOSE) start

# Stop containers without deleting them.
stop:
	$(COMPOSE) stop

restart:
	$(COMPOSE) restart

# Remove containers/network, but KEEP volumes.
down:
	$(COMPOSE) down

# Same as down. Persistent data is kept.
clean:
	$(COMPOSE) down --remove-orphans

# Full cleanup: containers + volumes + images.
fclean:
	$(COMPOSE) down -v --remove-orphans
	docker rmi -f nginx wordpress mariadb 2>/dev/null || true
	sudo rm -rf /home/$(USER)/data/mariadb
	sudo rm -rf /home/$(USER)/data/wordpress
	sudo sed -i "\|$(DOMAIN_NAME)|d" /etc/hosts

# Rebuild without deleting persistent data.
re:
	$(COMPOSE) down
	$(COMPOSE) up -d --build

ps:
	$(COMPOSE) ps

images:
	$(COMPOSE) images

volumes:
	docker volume ls

networks:
	docker network ls

# Validate and display the final Compose configuration.
config:
	$(COMPOSE) config

shell-db:
	$(COMPOSE) exec mariadb bash

shell-wp:
	$(COMPOSE) exec wordpress bash

shell-nginx:
	$(COMPOSE) exec nginx bash

# Open MariaDB client.
db:
	$(COMPOSE) exec mariadb mariadb

# Last 20 lines from each service.
logs:
	$(COMPOSE) logs --tail=20

logs-db:
	$(COMPOSE) logs --tail=20 mariadb

logs-wp:
	$(COMPOSE) logs --tail=20 wordpress

logs-nginx:
	$(COMPOSE) logs --tail=20 nginx

.PHONY: all up host build start stop restart down clean fclean re \
	ps images volumes networks config shell-db shell-wp shell-nginx db \
	logs logs-db logs-wp logs-nginx
