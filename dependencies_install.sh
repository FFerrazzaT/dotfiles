#!/bin/bash

# Verifica se o Tmux está instalado
if command -v tmux >/dev/null 2>&1; then
    echo "O Tmux está instalado no sistema."
else
    echo "O Tmux não está instalado no sistema."
    read -p "Deseja instalar o Tmux? (yes/no): " install_tmux
    if [ "$install_tmux" == "yes" ]; then
        sudo apt-get update
        sudo apt-get install -y tmux
        echo "O Tmux foi instalado com sucesso."
    else
        echo "O Tmux não foi instalado."
    fi
fi

# Verifica se o Zsh está instalado
if command -v zsh >/dev/null 2>&1; then
    echo "O Zsh está instalado no sistema."
else
    echo "O Zsh não está instalado no sistema."
    read -p "Deseja instalar o Zsh? (yes/no): " install_zsh
    if [ "$install_zsh" == "yes" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        echo "O Zsh foi instalado com sucesso."
    else
        echo "O Zsh não foi instalado."
    fi
fi

# Verifica se as dependências do Tmux estão instaladas
tmux_dependencies=("libevent-devel" "ncurses-devel")

missing_tmux_dependencies=()

for dep in "${tmux_dependencies[@]}"; do
    if yum list installed "$dep" >/dev/null 2>&1; then
        echo "A dependência $dep está instalada."
    else
        echo "A dependência $dep não está instalada."
        missing_tmux_dependencies+=("$dep")
    fi
done

if [ ${#missing_tmux_dependencies[@]} -eq 0 ]; then
    echo "Todas as dependências do Tmux estão instaladas."
else
    echo "As seguintes dependências do Tmux estão faltando: ${missing_tmux_dependencies[*]}"
    read -p "Deseja instalar as dependências do Tmux? (yes/no): " install_tmux_dependencies
    if [ "$install_tmux_dependencies" == "yes" ]; then
        sudo yum install -y "${missing_tmux_dependencies[@]}"
        echo "Dependências do Tmux instaladas com sucesso."
    else
        echo "As dependências do Tmux não foram instaladas."
    fi
fi

# Verifica se as dependências do Zsh estão instaladas
zsh_dependencies=("zsh-syntax-highlighting" "zsh-autosuggestions")

missing_zsh_dependencies=()

for dep in "${zsh_dependencies[@]}"; do
    if yum list installed "$dep" >/dev/null 2>&1; then
        echo "A dependência $dep está instalada."
    else
        echo "A dependência $dep não está instalada."
        missing_zsh_dependencies+=("$dep")
    fi
done

if [ ${#missing_zsh_dependencies[@]} -eq 0 ]; then
    echo "Todas as dependências do Zsh estão instaladas."
else
    echo "As seguintes dependências do Zsh estão faltando: ${missing_zsh_dependencies[*]}"
    read -p "Deseja instalar as dependências do Zsh? (yes/no): " install_zsh_dependencies
    if [ "$install_zsh_dependencies" == "yes" ]; then
        sudo yum install -y "${missing_zsh_dependencies[@]}"
        echo "Dependências do Zsh instaladas com sucesso."
    else
        echo "As dependências do Zsh não foram instaladas."
    fi
fi