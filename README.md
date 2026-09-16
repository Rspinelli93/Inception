# Inception

Containerized infrastructure project for the 42 Common Core. The repository is intentionally free of passwords, API keys, certificates, and private deployment files.

## Required private configuration

Before starting, provide the private configuration supplied with the project:

- `.env` with environment variables
- `secrets/` with secret files

Place both inside `srcs/`:

```text
srcs/
├── .env
└── secrets/
    ├── credentials.txt
    └── db_password.txt
```

Never commit real values. Keep them local and use placeholders in documentation.

If you do not have the original files, create local development versions:

```sh
mkdir -p srcs/secrets

cat > srcs/.env <<'EOF'
DOMAIN_NAME=login.42.fr
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=change-me-locally
EOF

printf '%s\n' 'change-me-locally' > srcs/secrets/db_password.txt
printf '%s\n' 'change-me-locally' > srcs/secrets/credentials.txt
```

Adjust variable names and secret filenames to match the `docker-compose.yml` and Dockerfiles in the implementation. These examples are placeholders only; replace them before any real deployment.

Add protection before working:

```gitignore
.env
secrets/
*.key
*.crt
```

## Safety check

This repository was created without importing credentials or password files. Before pushing future changes, inspect the staged file list and search for likely secrets:

```sh
git diff --cached --name-only
git diff --cached -- .env 'secrets/**'
rg -n --hidden -g '!*.md' '(PASSWORD|PASSWD|SECRET|TOKEN|API_KEY|PRIVATE_KEY)=' .
```

Review every match manually. A variable name is safe; a real value is not. Use GitHub secret scanning and rotate any credential that was accidentally exposed.

## Typical workflow

Once the implementation is present and private configuration is prepared:

```sh
cd srcs
docker compose build
docker compose up -d
docker compose ps
docker compose logs -f
```

The exact services, ports, health checks, and domain depend on the project files. Read the compose file before running it.

## 42 context

Inception belongs to the 42 Common Core infrastructure branch and is linked from the [curriculum hub](https://github.com/Rspinelli93/42-Common-Core/tree/main/Lvl05). The repository documents setup and safety boundaries without claiming validation of services that have not yet been added.
