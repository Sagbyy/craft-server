#!/bin/bash
set -euo pipefail

# Copier les configs PostgreSQL versionnées
sudo cp "$(dirname "$0")/../configs/postgresql.conf" /etc/postgresql/16/main/postgresql.conf
sudo cp "$(dirname "$0")/../configs/pg_hba.conf"      /etc/postgresql/16/main/pg_hba.conf

# Redémarrer le service
sudo systemctl restart postgresql
echo "✅ PostgreSQL configuré – écoute et accès distants activés"
