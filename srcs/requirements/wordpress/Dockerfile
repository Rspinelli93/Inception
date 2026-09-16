FROM debian:12

# PHP-FPM runs WordPress; php-mysql connects PHP to MariaDB.
RUN apt-get update && \
    apt-get install -y \
        php-fpm \
        php-mysql \
        mariadb-client \
        curl \
        ca-certificates \
		iproute2 \
        tar && \
    rm -rf /var/lib/apt/lists/*

# Download WordPress source files.
RUN curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress /usr/src/wordpress && \
    rm latest.tar.gz

# WP-CLI lets the script configure WordPress automatically.
RUN curl -o /usr/local/bin/wp \
    https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

ENTRYPOINT ["/usr/local/bin/init.sh"]
