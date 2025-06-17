#!/bin/bash

# Initialize environment variables
set -a
source ../.env
set +a

# Install Caddy
echo "[📡] Installing Caddy..."
apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
apt update
apt install caddy

# Install Node.js
echo "[📡] Installing Node.js..."
apt install -y nodejs npm

# Install Ngrok
echo "[📡] Installing Ngrok..."
snap install ngrok

# Install Strapi
echo "[📡] Installing Strapi..."
cd /home/modo/strapi-app
npm install

# Build
echo "[⚙️] Building Strapi..."
cd /home/modo/strapi-app
npm run build

# Start
echo "[⚙️] Starting Strapi..."
cd /home/modo/strapi-app
npm run start

# Configure Caddy
echo "[⚙️] Configuring Caddy..."
cp /home/modo/configs/Caddyfile /etc/caddy/Caddyfile
systemctl restart caddy

echo "[ℹ️] Caddy is running on port 80, you can access the Strapi admin panel at http://<your-ip>"

# 6. Configure Ngrok
echo "[⚙️] Configuring Ngrok..."
# if environnement varibale $NGROK_TOKEN is not set, then exit
if [ -z "$NGROK_AUTH_TOKEN" ]; then
    echo "[❌] NGROK_AUTH_TOKEN environment variable is not set"
    exit 1
fi

ngrok http 80