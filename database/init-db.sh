#!/bin/bash
set -euo pipefail

# Variables
DB_NAME="data-db"
DB_USER="dbuser"
DB_PASSWORD="gTU1ZwxE92Z77H83a33OZ046"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA_FILE="$SCRIPT_DIR/schema.sql"

# read pour all
sudo chmod a+r "$SCHEMA_FILE"
# pour traversé du chemin 
sudo chmod o+x "$(dirname "$SCRIPT_DIR")"
sudo chmod o+x "$SCRIPT_DIR"

# 1) create  rôle si nécessaire
sudo -u postgres psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${DB_USER}'" | grep -q 1 \
  || sudo -u postgres psql -c "CREATE USER ${DB_USER} WITH LOGIN PASSWORD '${DB_PASSWORD}';"

# 2) create BDD si nécessaire
sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}'" | grep -q 1 \
  || sudo -u postgres psql -c "CREATE DATABASE \"${DB_NAME}\" OWNER ${DB_USER};"

#  3) Appliquer le schéma
sudo -u postgres psql -d "${DB_NAME}" -f "${SCHEMA_FILE}"

# 4 ) Transférer la propriété des objets à dbuser et lui donner tous les droits
sudo -u postgres psql -d "${DB_NAME}" <<SQL
ALTER TABLE public.users              OWNER TO ${DB_USER};
ALTER TABLE public.events             OWNER TO ${DB_USER};
ALTER TABLE public.event_participants OWNER TO ${DB_USER};

ALTER SEQUENCE users_id_seq              OWNER TO ${DB_USER};
ALTER SEQUENCE events_id_seq             OWNER TO ${DB_USER};
ALTER SEQUENCE event_participants_id_seq OWNER TO ${DB_USER};

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${DB_USER};
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ${DB_USER};
SQL

echo "✅ Base '${DB_NAME}' prête : schéma appliqué et objets propriété de ${DB_USER}."
