#!/bin/bash
set -e

echo "[+] Updating system..."
apt update && apt upgrade -y

echo "[+] Installing dependencies..."
apt install -y net-tools

# echo "[+] Configuring SSH..."
# bash scripts/setup-ssh.sh