#!/bin/bash
set -e

apt install -y openssh-server
apt install -y zip

# Enable and start SSH service
systemctl enable ssh
systemctl start ssh


# Variables
USER="modo"
KEY_DIR="/home/$USER/.ssh"
PRIVATE_KEY="$KEY_DIR/id_rsa"
PUBLIC_KEY="$KEY_DIR/id_rsa.pub"
ZIP_PATH="/home/$USER/ssh-keys.zip"
SSHD_CONFIG="/etc/ssh/sshd_config"

# 1. Update SSH configuration
echo "[-] Updating SSH configuration..."
sed -i.bak 's/^#\?PermitRootLogin .*/PermitRootLogin no/' "$SSHD_CONFIG"

# 2. Restart SSH service
echo "[-] Restarting SSH service..."
systemctl restart ssh

# 3. Generate SSH key pair for user modo
echo "[-] Generating SSH key pair for $USER..."
sudo -u "$USER" mkdir -p "$KEY_DIR"
sudo -u "$USER" ssh-keygen -t rsa -b 4096 -f "$PRIVATE_KEY" -N ""

# 4. Add public key to authorized_keys
echo "[-] Configuring authorized_keys..."
sudo -u "$USER" cp "$PUBLIC_KEY" "$KEY_DIR/authorized_keys"

# 5. Set proper permissions
echo "[-] Setting permissions..."
chmod 700 "$KEY_DIR"
chmod 600 "$KEY_DIR/authorized_keys"
chown -R "$USER:$USER" "$KEY_DIR"

# 6. Create a ZIP archive containing the keys
echo "[-] Creating ZIP archive for SSH keys..."
sudo -u "$USER" zip -j "$ZIP_PATH" "$PRIVATE_KEY" "$PUBLIC_KEY"

echo "[✔] SSH setup complete. Archive created at: $ZIP_PATH"
