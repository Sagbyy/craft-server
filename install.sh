#!/bin/bash
set -e

echo "[+] Updating system..."
apt update && apt upgrade -y

echo "[+] Configuring SSH..."
bash scripts/setup-ssh.sh