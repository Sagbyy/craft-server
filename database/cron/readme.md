##  Database (PostgreSQL 16) — Installation, Configuration et Backup

### 1. Installation de PostgreSQL et création de l’utilisateur système
```bash
sudo apt update
sudo apt install -y postgresql postgresql-contrib

# Se placer à la racine du projet
cd ~/craft-server/craft-server

# Créer le dossier et les fichiers
mkdir -p database
touch database/schema.sql database/init-db.sh

# Rendre exécutable le script d’initialisation
chmod +x database/init-db.sh

# Modifier /etc/postgresql/16/main/postgresql.conf
sudo sed -i "s/^#listen_addresses =.*/listen_addresses = '*'/" /etc/postgresql/16/main/postgresql.conf

# Modifier /etc/postgresql/16/main/pg_hba.conf
echo "host    data-db    dbuser    0.0.0.0/0    md5" | sudo tee -a /etc/postgresql/16/main/pg_hba.conf

# Redémarrer PostgreSQL
sudo systemctl restart postgresql

# Créer le script et lui attribuer des droits d’exécution
sudo nano /usr/local/bin/backup_postgresql.sh
sudo chmod +x /usr/local/bin/backup_postgresql.sh

#test manuel, du backup
sudo /usr/local/bin/backup_postgresql.sh
ls -lh /opt/backup/postgresql
