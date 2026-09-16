FROM debian:12

# DOMAIN_NAME comes from docker-compose.yml at build time.
ARG DOMAIN_NAME

# Install all dependencies and Generate a self-signed TLS certificate.
RUN apt-get update && \
    apt-get install -y nginx openssl curl && \
    mkdir -p /etc/nginx/ssl && \
    openssl req \
        -x509 \
        -nodes \
        -days 365 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/CN=${DOMAIN_NAME}" && \
    \
    rm -rf /var/lib/apt/lists/*

COPY conf/nginx.conf /etc/nginx/nginx.conf

# Foreground mode keeps NGINX as the container's main process.
CMD ["nginx", "-g", "daemon off;"]
