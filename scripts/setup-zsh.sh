#!/bin/bash
set -e

# Variables
USER="modo"
HOME="/home/$USER"

# 1. Install ZSH
echo "[-] Installing ZSH for $USER..."
apt install -y zsh

# 2. Set ZSH as default shell
echo "[-] Setting ZSH as default shell..."
chsh -s $(which zsh) $USER

# 3. Copy .zshrc file
echo "[-] Copying .zshrc file..."

if [ -e /home/$USER/.zshrc ]; then
  echo "[-] Removing existing .zshrc file..."
  rm /home/$USER/.zshrc
fi

cp ./configs/.zshrc /home/$USER/.zshrc
chown $USER:$USER /home/$USER/.zshrc

# 4. Installing Oh My ZSH
echo "[-] Installing Oh My ZSH..."

if [ -e /home/$USER/.oh-my-zsh ]; then
  echo "[-] Removing existing Oh My ZSH directory..."
  rm -rf /home/$USER/.oh-my-zsh
fi

# 5. Install Oh My ZSH
su - $USER -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'

# 6. Fix Oh My ZSH permissions
echo "[-] Fixing Oh My ZSH permissions..."
chmod -R g-w,o-w $HOME/.oh-my-zsh
chown -R $USER:$USER $HOME/.oh-my-zsh

