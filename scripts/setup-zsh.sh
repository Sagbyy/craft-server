#!/bin/bash
set -e

# Variables
USER="modo"

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

if [ -e /root/.oh-my-zsh ]; then
  echo "[-] Removing existing Oh My ZSH directory..."
  rm -rf /root/.oh-my-zsh
fi

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chown -R $USER:$USER /home/$USER/.oh-my-zsh

# 5. Configuring Haribo Theme
echo "[-] Configuring Haribo Theme..."
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# 6. Changing shell to ZSH (moved to the end)
echo "[-] Changing shell to ZSH..."
exec -l zsh
