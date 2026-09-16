FROM debian:12

RUN apt-get update && \
    apt-get install -y mariadb-server && \
	#creates the socket directory MariaDB expects.
    mkdir -p /run/mysqld && \
	# gives ownership to the mysql user, so MariaDB can write there.
    chown -R mysql:mysql /run/mysqld /var/lib/mysql && \
    rm -rf /var/lib/apt/lists/*

	# Copy .cnf to let MariaDB accept connections from other containers, including WordPress. (0.0.0.0)
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
# Copy from host machine the .sh to init mariadb
COPY tools/init.sh /usr/local/bin/init.sh

# Change the .sh to executable
RUN chmod +x /usr/local/bin/init.sh

ENTRYPOINT ["/usr/local/bin/init.sh"]
