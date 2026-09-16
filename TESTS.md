# TESTING

### Test config file first:

```bash
make config
#tests if the config file is propperly written
```

Then:
```bash
make all
# Will run docker compose up and set up all images, volumes, and
# the network and launch the containers.
```
After all is running...

## Everything runs propperly:
```bash
make ps
# Check the containers are running
```
### We want to see here all 3 containers
------------
```bash
#open wordpress continer terminal
make shell-wp
#inside wordpress terminal we check if we are connected to mariadb, we should get an ip
getent hosts mariadb 
# Then:
mariadb -h mariadb -u wpuser -p
# pass at: srcs/secrets/db_password.txt
```
### Inside mariadb we check if the wp tables are propperly created:
```bash
SHOW DATABASES;
USE wordpress;
SHOW TABLES;
EXIT;
```

Finally we check FastCGI and connection to NGINX:
```bash
ps aux # Should return php-fpm8.2. (Is the fastCGI runinng, this is the responsable of running php in wordpress)
ss -lntp # Should return port 0.0.0.0:9000 (That is needed to see if NGINX can reach WordPress)

exit #go back to host machine
```

## Test NGINX configuration:

```bash
make shell-nginx #enter bash terminal
nginx -t #run test, expect: "syntax is ok test is successful"
ss -lntp #check is connected in port 443
```
### After we check http vs https
```bash
curl -k https://rspinell.42.fr #we expect an html (-k means: accept the self-signed certificate)
curl http://rspinell.42.fr # this should fail, port 80 is not exposed.
```

### Finally Check TLS vesrsions
```bash
openssl s_client -connect rspinell.42.fr:443 -tls1_2
openssl s_client -connect rspinell.42.fr:443 -tls1_3

exit
```

## Test Volumes configuration and persistent data:
```bash
make volumes #expect to see the volumes created (maria ans wp)

# Then inspect both:
docker volume inspect <name>

# AFind the mount point with docker inspect <mariadb or wordpress>
/var/lib/mysql #maria
/var/www/html  #wordpress

# enter terminal of each of the containers
make shell-db
# or
make shell-wp

#create a document inside the container folders
cat > /path/to/folder/test.txt <<EOF
Ill stay here FOREVER.. FORever.. Forever.. forever.. forev.. f..
EOF

#exit shell
exit
```
### Then check again if they still there
```bash
make down	#clear containers
make up		#up containers

# enter terminal of each of the containers
make shell-db
# or
make shell-wp

# And find the .txt doc
exit
```

### Find users in .env and passwords in the secrets folder

