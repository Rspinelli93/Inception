# User Documentation

## Start

```bash
make
```

## Stop

```bash
make down
```

## Check Services

```bash
make ps
```

The following services should be running:

```text
nginx
wordpress
mariadb
```

## Website

```text
https://<login>.42.fr
```

## WordPress Administration

```text
https://<login>.42.fr/wp-admin
```

Use the locally configured WordPress administrator credentials.

## Credentials

Passwords are stored locally in:

```text
srcs/secrets/
```

They must not be committed to Git.

## Volumes

```bash
make volumes
```

## Networks

```bash
make networks
```

