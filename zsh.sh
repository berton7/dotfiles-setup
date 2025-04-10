#!/usr/bin/env bash

set -euo pipefail

DOTFILES=$HOME/dotfiles

[ ! -d $DOTFILES ] && git clone https://github.com/berton7/dotfiles $DOTFILES
[ ! -d "$DOTFILES/zsh/.oh-my-zsh" ] && ZSH="$DOTFILES/zsh/.oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
[ ! -d "$DOTFILES/zsh/.oh-my-zsh/custom/themes/powerlevel10k" ] && git clone https://github.com/romkatv/powerlevel10k.git "$DOTFILES/zsh/.oh-my-zsh/custom/themes/powerlevel10k" --depth 1
[ ! -d "$DOTFILES/zsh/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$DOTFILES/zsh/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" --depth 1
[ ! -d "$DOTFILES/zsh/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$DOTFILES/zsh/.oh-my-zsh/custom/plugins/zsh-autosuggestions" --depth 1

[ ! -f "$HOME/.zprofile" ] && ln -s "$DOTFILES/shell/profile" "$HOME/.zprofile"
