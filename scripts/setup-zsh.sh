#!/bin/bash
set -e

# 1. Install ZSH
echo "[-] Installing ZSH..."
apt install -y zsh

# 2. Set ZSH as default shell
echo "[-] Setting ZSH as default shell..."
chsh -s $(which zsh) $USER

# 3. Copy .zshrc file
echo "[-] Copying .zshrc file..."
cp .zshrc /home/$USER/.zshrc

# 4. Changing shell to ZSH
echo "[-] Changing shell to ZSH..."
exec -l zsh

# 5. Installing Oh My ZSH
echo "[-] Installing Oh My ZSH..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 6. Configuring Haribo Theme
echo "[-] Configuring Haribo Theme..."
git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# 7. Copy .zshrc file
echo "[-] Copying .zshrc file..."
cp .zshrc /home/$USER/.zshrc
