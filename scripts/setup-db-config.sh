#!/bin/bash
set -euo pipefail

# Copier les configs versionnées
sudo cp "$(dirname "$0")/../configs/postgresql.conf" /etc/postgresql/16/main/postgresql.conf
sudo cp "$(dirname "$0")/../configs/pg_hba.conf"      /etc/postgresql/16/main/pg_hba.conf

# Redémarrer PostgreSQL
sudo systemctl restart postgresql
