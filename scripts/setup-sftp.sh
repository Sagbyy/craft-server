#!/bin/bash
set -euo pipefail

# Variables
SFTP_USER="sftpuser"
SFTP_PASS="S3cur3P@ss!"
SFTP_ROOT="/srv/sftp"
SFTP_DIR="$SFTP_ROOT/files"
VSFTPD_CONF="/etc/vsftpd.conf"

# 0) Nettoyer un éventuel ancien utilisateur (optionnel)
# sudo deluser --remove-home $SFTP_USER || true

# 1) Créer l’utilisateur sans shell s’il n’existe pas
if ! id -u "$SFTP_USER" &>/dev/null; then
  sudo useradd -m -d "$SFTP_DIR" -s /usr/sbin/nologin "$SFTP_USER"
  echo "✅ Utilisateur $SFTP_USER créé."
else
  echo "ℹ️ Utilisateur $SFTP_USER déjà existant, on met à jour le mot de passe."
fi

# 2) Définir son mot de passe
echo "$SFTP_USER:$SFTP_PASS" | sudo chpasswd
echo "✅ Mot de passe mis à jour pour $SFTP_USER."

# 3) Préparer l’arborescence et le chroot
sudo mkdir -p "$SFTP_ROOT"
sudo chown root:root "$SFTP_ROOT"
sudo mkdir -p "$SFTP_DIR"
sudo chown "$SFTP_USER:$SFTP_USER" "$SFTP_DIR"
echo "✅ Arborescence $SFTP_ROOT et $SFTP_DIR prête."

# 4) Sauvegarder la config vsftpd existante
sudo cp "$VSFTPD_CONF"{,.bak}
echo "✅ Sauvegarde de $VSFTPD_CONF vers ${VSFTPD_CONF}.bak"

# 5) Écrire une config vsftpd minimaliste et fonctionnelle
sudo tee "$VSFTPD_CONF" > /dev/null <<CONF
# Répertoire sécurisé nécessaire pour le chroot
secure_chroot_dir=/var/run/vsftpd/empty

# Forcer l’écoute en IPv4 (port 21)
listen=YES
listen_ipv6=NO

anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES

xferlog_enable=YES
xferlog_std_format=YES
CONF
echo "✅ Configuration vsftpd écrite dans $VSFTPD_CONF."

# 6) Créer le dossier empty pour le chroot de vsftpd
sudo mkdir -p /var/run/vsftpd/empty
sudo chown root:root /var/run/vsftpd/empty
sudo chmod 755 /var/run/vsftpd/empty
echo "✅ Répertoire secure_chroot_dir prêt."

# 7) Redémarrer et activer vsftpd
sudo systemctl restart vsftpd
sudo systemctl enable vsftpd
echo "✅ Service vsftpd redémarré et activé au démarrage."

echo "🎉 vsftpd est configuré : user=$SFTP_USER chrooté dans $SFTP_DIR"
