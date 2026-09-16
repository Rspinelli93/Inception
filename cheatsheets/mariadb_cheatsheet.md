# MariaDB Cheatsheet for Inception

This cheatsheet covers the MariaDB commands and Docker/Compose commands used while learning and building the MariaDB part of the 42 Inception project.

---

## 1. Open the MariaDB client

Start MariaDB inside the container:

```bash
mariadb
```

Connect as a specific user:

```bash
mariadb -u wpuser -p
```

Flags:

- `-u wpuser` → connect as the user `wpuser`
- `-p` → ask for the password interactively

Exit MariaDB:

```sql
EXIT;
```

or:

```sql
QUIT;
```

---

## 2. Databases

Show all databases:

```sql
SHOW DATABASES;
```

Create a database:

```sql
CREATE DATABASE wordpress;
```

Delete a database:

```sql
DROP DATABASE wordpress;
```

Select a database:

```sql
USE wordpress;
```

Show the currently selected database:

```sql
SELECT DATABASE();
```

---

## 3. Tables

Show tables in the current database:

```sql
SHOW TABLES;
```

Create a table:

```sql
CREATE TABLE test_table (
    id INT PRIMARY KEY,
    message VARCHAR(100)
);
```

Describe a table:

```sql
DESCRIBE test_table;
```

or:

```sql
DESC test_table;
```

Delete a table:

```sql
DROP TABLE test_table;
```

---

## 4. Insert data

Insert one row:

```sql
INSERT INTO test_table
VALUES (1, 'hello');
```

Preferred explicit form:

```sql
INSERT INTO test_table (id, message)
VALUES (1, 'hello');
```

Insert multiple rows:

```sql
INSERT INTO test_table (id, message)
VALUES
    (1, 'hello'),
    (2, 'docker'),
    (3, 'inception');
```

---

## 5. Read data

Show all rows and columns:

```sql
SELECT * FROM test_table;
```

Show specific columns:

```sql
SELECT id, message FROM test_table;
```

Filter rows:

```sql
SELECT * FROM test_table
WHERE id = 1;
```

Count rows:

```sql
SELECT COUNT(*) FROM test_table;
```

---

## 6. Update data

Update a row:

```sql
UPDATE test_table
SET message = 'updated'
WHERE id = 1;
```

Check the result:

```sql
SELECT * FROM test_table;
```

---

## 7. Delete data

Delete one row:

```sql
DELETE FROM test_table
WHERE id = 1;
```

Delete all rows but keep the table:

```sql
DELETE FROM test_table;
```

Or reset the table contents quickly:

```sql
TRUNCATE TABLE test_table;
```

---

## 8. MariaDB users

Show MariaDB users:

```sql
SELECT User, Host FROM mysql.user;
```

Create a user:

```sql
CREATE USER 'wpuser'@'%'
IDENTIFIED BY 'wppassword';
```

Meaning:

- `wpuser` → username
- `%` → allow connections from other hosts/containers

This matters in Inception because WordPress connects from a different container.

---

## 9. Permissions

Grant access to the WordPress database:

```sql
GRANT ALL PRIVILEGES
ON wordpress.*
TO 'wpuser'@'%';
```

Apply privilege changes:

```sql
FLUSH PRIVILEGES;
```

Check the user's permissions:

```sql
SHOW GRANTS FOR 'wpuser'@'%';
```

---

## 10. Remove or modify users

Remove a user:

```sql
DROP USER 'wpuser'@'%';
```

Change a password:

```sql
ALTER USER 'wpuser'@'%'
IDENTIFIED BY 'newpassword';
```

---

## 11. Test the WordPress user

Exit the current MariaDB session:

```sql
EXIT;
```

Reconnect as the WordPress user:

```bash
mariadb -u wpuser -p
```

Then test:

```sql
SHOW DATABASES;
USE wordpress;
```

If `USE wordpress;` works, the user has access to the database.

---

## 12. Useful server information

MariaDB version:

```sql
SELECT VERSION();
```

Current connection user:

```sql
SELECT USER();
```

Authenticated MariaDB account:

```sql
SELECT CURRENT_USER();
```

Server hostname:

```sql
SELECT @@hostname;
```

MariaDB port:

```sql
SHOW VARIABLES LIKE 'port';
```

Bind address:

```sql
SHOW VARIABLES LIKE 'bind_address';
```

The bind address matters in Inception because WordPress must reach MariaDB over the Docker network.

---

# Docker and Compose Commands for MariaDB

## 13. Check service status

Show running Compose services:

```bash
docker compose ps
```

Show running and stopped Compose containers:

```bash
docker compose ps -a
```

Show all Docker containers:

```bash
docker ps -a
```

---

## 14. MariaDB logs

Show MariaDB logs:

```bash
docker compose logs mariadb
```

Follow MariaDB logs live:

```bash
docker compose logs -f mariadb
```

Show logs using the container name directly:

```bash
docker logs mariadb
```

---

## 15. Enter the MariaDB container

Open Bash inside the running MariaDB container:

```bash
docker compose exec mariadb bash
```

Then start MariaDB:

```bash
mariadb
```

Or start the MariaDB client directly from the host without opening Bash first:

```bash
docker compose exec mariadb mariadb
```

---

## 16. Build and start MariaDB

Build only the MariaDB image:

```bash
docker compose build mariadb
```

Rebuild MariaDB without cache:

```bash
docker compose build --no-cache mariadb
```

Start only MariaDB:

```bash
docker compose up -d mariadb
```

Rebuild and recreate MariaDB:

```bash
docker compose up -d --build mariadb
```

Stop MariaDB:

```bash
docker compose stop mariadb
```

Restart MariaDB:

```bash
docker compose restart mariadb
```

Remove the stopped MariaDB service container:

```bash
docker compose rm -f mariadb
```

---

## 17. Volumes

Show Docker volumes:

```bash
docker volume ls
```

Inspect a volume:

```bash
docker volume inspect <volume-name>
```

For example:

```bash
docker volume inspect inception_mariadb-data
```

MariaDB typically stores database files in:

```text
/var/lib/mysql
```

Conceptually:

```text
MariaDB container
       |
       v
/var/lib/mysql
       |
       v
named Docker volume
```

---

## 18. Persistence test

Create test data:

```sql
CREATE DATABASE persistence_test;

USE persistence_test;

CREATE TABLE test (
    id INT PRIMARY KEY,
    message VARCHAR(100)
);

INSERT INTO test VALUES (1, 'persistent');
```

Stop and remove the Compose containers but keep the named volumes:

```bash
docker compose down
```

Start MariaDB again:

```bash
docker compose up -d mariadb
```

Reconnect:

```bash
docker compose exec mariadb mariadb
```

Check the data:

```sql
USE persistence_test;
SELECT * FROM test;
```

If the row still exists, the named volume is working correctly.

---

## 19. Remove persistent data

Normal Compose shutdown keeps named volumes:

```bash
docker compose down
```

Remove containers, network, and named volumes:

```bash
docker compose down -v
```

Warning: `-v` deletes persistent database data associated with the Compose project.

---

# MariaDB Dockerfile Concepts Used So Far

A basic learning Dockerfile may look like:

```dockerfile
FROM debian:12

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql && \
    rm -rf /var/lib/apt/lists/*

USER mysql

CMD ["mysqld"]
```

Important parts:

- `apt-get install -y mariadb-server` → installs MariaDB
- `mkdir -p /run/mysqld` → creates the runtime socket directory MariaDB needs
- `chown -R mysql:mysql ...` → gives the MariaDB user ownership of required directories
- `USER mysql` → runs the container process as the `mysql` user instead of root
- `CMD ["mysqld"]` → launches the MariaDB server when the container starts

This is still a learning version. The final Inception implementation should automate database initialization, users, credentials, and configuration.

---

# Important Inception SQL Commands to Memorize

```sql
SHOW DATABASES;

CREATE DATABASE wordpress;

USE wordpress;

SHOW TABLES;

CREATE USER 'wpuser'@'%'
IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES
ON wordpress.*
TO 'wpuser'@'%';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'wpuser'@'%';

SELECT User, Host FROM mysql.user;
```

---

# Important Inception Docker Commands to Memorize

```bash
docker compose build mariadb

docker compose up -d mariadb

docker compose ps -a

docker compose logs mariadb

docker compose logs -f mariadb

docker compose exec mariadb bash

docker compose exec mariadb mariadb

docker volume ls

docker volume inspect <volume-name>
```

---

# Mental Model for Inception

```text
WordPress container
        |
        | database host: mariadb
        | database name: wordpress
        | username/password
        v
MariaDB container
        |
        v
/var/lib/mysql
        |
        v
named Docker volume
```

For the real project, WordPress should connect to the hostname `mariadb`, not `localhost`, because MariaDB runs in a separate container on the shared Docker network.

