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

# Install Oh My ZSH
su - $USER -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'

# Fix Oh My ZSH permissions
echo "[-] Fixing Oh My ZSH permissions..."
chmod -R g-w,o-w $HOME/.oh-my-zsh
chown -R $USER:$USER $HOME/.oh-my-zsh

# 5. Configuring Haribo Theme
echo "[-] Configuring Haribo Theme..."
git clone https://github.com/haribo/omz-haribo-theme.git $HOME/.oh-my-zsh/themes/haribo
cp $HOME/.oh-my-zsh/themes/haribo/haribo.zsh-theme $HOME/.oh-my-zsh/custom/themes/haribo.zsh-theme

# 6. Changing shell to ZSH (moved to the end)
echo "[-] Changing shell to ZSH..."
exec -l zsh
