#!/usr/bin/env bash

set -euo pipefail

DOTFILES=$HOME/dotfiles
pkgs_to_install=""

check_pkgs() {
    for arg in "$@"; do 
        if ! dpkg -s $arg &>/dev/null;
        then
            pkgs_to_install="${pkgs_to_install} $arg"
            echo ${pkgs_to_install}
        fi
    done
}

install_pkgs() {
    if [[ -n "$pkgs_to_install" ]]; then
        sudo apt-get update
        sudo apt-get upgrade
        sudo apt-get install ${pkgs_to_install}
    fi
}

install_fonts() {
    
    if ! fc-list | grep Meslo ; then
        [ ! -d ~/.fonts ] && mkdir ~/.fonts
        pushd ~/.fonts
        wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
        wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
        wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
        wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

        fc-cache -f
        popd
    fi
}

install_ohmyzsh() {
    install_fonts

    [ ! -d $DOTFILES ] && git clone https://github.com/berton7/dotfiles $DOTFILES
    [ ! -d "$DOTFILES/zsh/.oh-my-zsh" ] && ZSH="$DOTFILES/zsh/.oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    [ ! -d "$DOTFILES/zsh/.oh-my-zsh/custom/themes/powerlevel10k" ] && git clone https://github.com/romkatv/powerlevel10k.git "$DOTFILES/zsh/.oh-my-zsh/custom/themes/powerlevel10k" --depth 1
    [ ! -d "$DOTFILES/zsh/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ] && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$DOTFILES/zsh/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" --depth 1
    [ ! -d "$DOTFILES/zsh/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ] && git clone https://github.com/zsh-users/zsh-autosuggestions "$DOTFILES/zsh/.oh-my-zsh/custom/plugins/zsh-autosuggestions" --depth 1

    [ -f "$HOME/.zprofile" ] && rm ~/.zprofile
    ln -s "$DOTFILES/shell/profile" "$HOME/.zprofile"
}

configure_git() {
    [ -f "$HOME/.gitconfig" ] && rm ~/.gitconfig
    ln -s "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
}

check_pkgs zsh git wget
install_pkgs
install_ohmyzsh

configure_git
