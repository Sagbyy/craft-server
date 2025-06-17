#!/bin/bash
set -e

# Initialize environment variables
set -a
source .env
set +a

echo "[🚨] Don't forget to set the environment variables in the .env file"

ask_step() {
    read -p "⏩ [*] Would you want to execute this step : $1 ? [y/n] " response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        return 0
    else
        echo "⏩ [*] Skipping step : $1 "
        return 1
    fi
}

if ask_step "Updating system"; then
    echo "[+] Updating system..."
    apt update && apt upgrade -y
fi

if ask_step "Installing dependencies"; then
    echo "[+] Installing dependencies..."
    apt install -y net-tools
    apt install -y zip
fi

if ask_step "Configuring SSH"; then
    echo "[+] Configuring SSH..."
    bash scripts/setup-ssh.sh
fi

if ask_step "Configuring ZSH"; then
    echo "[+] Configuring ZSH..."
    bash scripts/setup-zsh.sh
fi

# ! Last step
if ask_step "Configuring Haribo Theme"; then
    echo "[+] Configuring Haribo Theme..."
    bash scripts/setup-haribo-theme.sh
fi