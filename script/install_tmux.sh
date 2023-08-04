#!/bin/bash

function custom_tmux_config() {
    read -p "Deseja instalar uma configuracao personalizada o tmux? (yes/no): " install
    if [ "$install" == "yes" ]; then
        read -p "Escolha o modelo: [local|remoto]: " escolha
        source ../sauce/tmux_sauce.sh 
        tmux_sauce $escolha
    fi
}

# Função para instalar o tmux a partir do código-fonte
function install_tmux_from_source() {
     # Instalar dependências necessárias
    if [ "$PACKAGE_MANAGER" == "apt-get" ]; then
        sudo apt-get update && sudo apt-get install -y automake build-essential pkg-config libevent-dev libncurses-dev
    elif [ "$PACKAGE_MANAGER" == "dnf" ]; then
        sudo dnf install -y automake gcc ncurses-devel libevent-devel
    elif [ "$PACKAGE_MANAGER" == "zypper" ]; then
        sudo zypper install -y automake gcc ncurses-devel libevent-devel
    elif [ "$PACKAGE_MANAGER" == "pacman" ]; then
        sudo pacman -S --needed base-devel ncurses libevent
    else
        error "Não foi possível determinar o gerenciador de pacotes ou distribuição não suportada."
    fi

    # Clonar o repositório do tmux e compilá-lo
    if ! git clone https://github.com/tmux/tmux.git; then
        error "Falha ao clonar o repositório do tmux."
    fi

    cd tmux

    # Opcionalmente, você pode especificar uma versão/tag específica do tmux usando o comando abaixo:
    # git checkout vX.Y.Z

    sh autogen.sh
    ./configure && make
    sudo make install

     # Verificar a versão do NeoVim após a instalação
    if command -v tmux &>/dev/null && [[ "$(tmux --V | awk 'NR==1 {print $2}')" >= "$required_version" ]]; then
        echo "tmux instalado com sucesso a partir do código-fonte com uma versão superior a 3.2a."
        custom_tmux_config
    else
      error "Falha ao instalar o tmux a partir do código-fonte com uma versão superior a 3.2a."
    fi

    # Limpeza
    cd ..
    rm -rf tmux
}

function install_tmux(){
  PACKAGE_MANAGER="$1"
  # Verificar se o tmux está instalado
  if command -v tmux &>/dev/null; then
    installed_version=$(tmux -V | awk 'NR==1 {print $2}')
    required_version="3.2a"

    if [[ "$installed_version" < "$required_version" ]]; then
      install_tmux_from_source
    else
      echo "tmux está instalado com uma versão superior a 3.2a."
      custom_tmux_config  
    fi
  else
    echo "tmux não está instalado no sistema."
  fi
}