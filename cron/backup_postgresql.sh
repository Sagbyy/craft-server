#!/bin/bash

#crée le fichier et luia attribuer des droits d'execution
#sudo nano /usr/local/bin/backup_postgresql.sh
#sudo chmod +x    /usr/local/bin/backup_postgresql.sh

#pour tester manuellement et voir 
#sudo /usr/local/bin/backup_postgresql.sh
#ls -lh /opt/backup/postgresql

set -euo pipefail

DB_NAME="data-db"
DB_USER="dbuser"
DB_PASS="gTU1ZwxE92Z77H83a33OZ046"
BACKUP_DIR="/opt/backup/postgresql"
TIMESTAMP=$(date + '%F_%H-%M-%S')

#crée mon dos de backup
mkdir -p "$BACKUP_DIR"

#compresse et redirige le dump vers le bon repertoire 
PGPASSWORD="$DB_PASS" \
    pg_dump -U "$DB_USER" -F c "DB_NAME" \
    > "$BACKUP_DIR"/${DB_NAME}_${TIMESTAMP}.
    
#supprimer tous les de plus de 7 jours
find "$BACKUP_DIR" -type f -mtime +7 -delete

#message de confirmation 
echo "Backup of ${DB_NAME} completed : $BACKUP_DIR/${DB_NAME}_${TIMESTAMP}.dump"
