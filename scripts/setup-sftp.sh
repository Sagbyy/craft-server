#!/bin/bash
set -euo pipefail

# Copier la config vsftpd versionnée
sudo cp "$(dirname "$0")/../configs/vsftpd.conf" /etc/vsftpd.conf

# Préparer le répertoire empty pour le chroot
sudo mkdir -p /var/run/vsftpd/empty
sudo chown root:root /var/run/vsftpd/empty
sudo chmod 755 /var/run/vsftpd/empty

# (Re)créer l’utilisateur SFTP et son mot de passe
SFTP_USER="sftpuser"
SFTP_PASS="S3cur3P@ss!"
SFTP_ROOT="/srv/sftp"
SFTP_DIR="$SFTP_ROOT/files"

if ! id -u "$SFTP_USER" &>/dev/null; then
  sudo useradd -m -d "$SFTP_DIR" -s /usr/sbin/nologin "$SFTP_USER"
fi
echo "$SFTP_USER:$SFTP_PASS" | sudo chpasswd

# Préparer l’arborescence de chroot
sudo mkdir -p "$SFTP_ROOT"
sudo chown root:root "$SFTP_ROOT"
sudo mkdir -p "$SFTP_DIR"
sudo chown "$SFTP_USER:$SFTP_USER" "$SFTP_DIR"

# Redémarrer le service
sudo systemctl restart vsftpd
echo "✅ vsftpd déployé – $SFTP_USER chrooté dans $SFTP_DIR"

