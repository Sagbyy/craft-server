#!/bin/bash

set -euo pipefail

DB_NAME="data-db"
DB_USER="dbuser"
DB_PASS="gTU1ZwxE92Z77H83a33OZ046"
BACKUP_DIR="/opt/backup/postgresql"
TIMESTAMP=$(date "+%F_%H-%M-%S")

#crée de mon dos de backup
mkdir -p "$BACKUP_DIR"

#compresse et redirige le dump vers le bon repertoire
PGPASSWORD="$DB_PASS" \
  pg_dump -h localhost -p 5432 \
          -U "$DB_USER" -F c "$DB_NAME" \
  > "$BACKUP_DIR/${DB_NAME}_${TIMESTAMP}.dump"

#suppr tous les de plus de 7 jours
find "$BACKUP_DIR" -type f -mtime +7 -delete

#message de confirmation
echo "Backup of ${DB_NAME} completed : $BACKUP_DIR/${DB_NAME}_${TIMESTAMP}.dump"

# Backup PostgreSQL tous les 2 jour a 02:04
sudo sh -c 'echo "4 2 */2 * * root /usr/local/bin/backup_postgresql.sh >> /var/log/backup_pg.log 2>&1" >> /etc/crontab'