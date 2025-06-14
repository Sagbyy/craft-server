#!/bin/bash

# Variables
USER="modo"
HOME="/home/$USER"

# 1. Configuring Haribo Theme
echo "[-] Configuring Haribo Theme..."
git clone https://github.com/haribo/omz-haribo-theme.git $HOME/.oh-my-zsh/themes/haribo
cp $HOME/.oh-my-zsh/themes/haribo/haribo.zsh-theme $HOME/.oh-my-zsh/custom/themes/haribo.zsh-theme

# 2. Changing shell to ZSH
echo "[-] Changing shell to ZSH..."
exec -l zsh

# 3. Configure .zshrc
echo "[-] Configuring .zshrc..."
cp $HOME/.zshrc $HOME/.zshrc.bak
cp ./configs/.zshrc $HOME/.zshrc
chown $USER:$USER $HOME/.zshrc