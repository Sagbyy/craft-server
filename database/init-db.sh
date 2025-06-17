#!/bin/bash
# database/init-db.sh
# Script d'initialisation de PostgreSQL pou le projet

set -euo pipefail

# --- Variables---
DB_NAME="data-db"
DB_USER="dbuser"
DB_PASSWORD="gTU1ZwxE92Z77H83a33OZ046"
SCHEMA_FILE="$(dirname "$0")/schema.sql"

# 1) Switch vers l’utilisateur postgres
sudo -u postgres bash <<EOF

# 2) Création de l’utilisateur et de la BDD
psql <<PSQL
CREATE USER ${DB_USER} WITH LOGIN PASSWORD '${DB_PASSWORD}';
CREATE DATABASE "${DB_NAME}" OWNER ${DB_USER};
GRANT ALL PRIVILEGES ON DATABASE "${DB_NAME}" TO ${DB_USER};
\connect "${DB_NAME}"
\i '${SCHEMA_FILE}'
PSQL

EOF

echo "✅ Base '${DB_NAME}' créée avec l’utilisateur '${DB_USER}' et schéma appliqué."
