#!/bin/bash

# Função para desinstalar configuração existente
function uninstall_config() {
    if [ -d ~/.config/nvim ]; then
        echo "Desinstalando configuração existente..."
        rm -rf ~/.config/nvim
    fi
}

# Função para instalar o Nvchad
function install_nvchad() {
    uninstall_config
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth
    nvim +PackerSync
}

# Função para instalar o Luavim
function install_luavim() {
    uninstall_config
    git clone https://github.com/ChristianChiarulli/LunarVim ~/.config/nvim
    cd ~/.config/nvim || exit
    ./utils/installer/install.sh
}

# Função para instalar o Lazy Vim
function install_lazyvim() {
    uninstall_config
    git clone https://github.com/junegunn/vim-plug.git ~/.config/nvim/autoload
    cp ~/path/to/your/lazyvimrc ~/.config/nvim/init.vim
    nvim +PlugInstall +qall
}

# Função para instalar o LunarVim
function install_lunarvim() {
    uninstall_config
    git clone https://github.com/LunarVim/LunarVim.git ~/.config/nvim
    cd ~/.config/nvim || exit
    ./install.sh
}

function nvim_sauce(){
    # Verifica se o Nvim está instalado
    if ! command -v nvim &>/dev/null; then
        echo "O Nvim não está instalado. Por favor, instale o Nvim antes de continuar."
        exit 1
    fi

    # Verifica o argumento fornecido para escolher a instalação
    if [ "$1" = "nvchad" ]; then
        install_nvchad
    elif [ "$1" = "luavim" ]; then
        install_luavim
    elif [ "$1" = "lazyvim" ]; then
        install_lazyvim
    elif [ "$1" = "lunarvim" ]; then
        install_lunarvim
    else
        echo "Escolha invalida"
        exit 1
    fi
}