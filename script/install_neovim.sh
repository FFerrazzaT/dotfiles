#!/bin/bash

function custom_nvim_config() {
    read -p "Deseja instalar uma configuracao personalizada o neovim? (yes/no): " install
    if [ "$install" == "yes" ]; then
        read -p "Escolha o modelo: [nvchad|luavim|lazyvim|lunarvim]: " escolha
        source ../sauce/nvim_sauce.sh 
        nvim_sauce $escolha
    fi
}

# Função para instalar o NeoVim a partir do código-fonte
function install_nvim_from_source() {
    echo "Instalando o NeoVim a partir do código-fonte..."

    # Instalar dependências necessárias
    if [ "$PACKAGE_MANAGER" == "apt-get" ]; then
      sudo apt-get update && sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip
    elif [ "$PACKAGE_MANAGER" == "dnf" ]; then
      sudo dnf install -y ninja-build gettext libtool autoconf automake cmake gcc gcc-c++ make pkgconfig unzip
    elif [ "$PACKAGE_MANAGER" == "zypper" ]; then
      sudo zypper install -y ninja gettext-tools libtool autoconf automake cmake gcc gcc-c++ make pkg-config unzip
    elif [ "$PACKAGE_MANAGER" == "pacman" ]; then
      sudo pacman -S --needed base-devel cmake unzip
    else
      error "Não foi possível determinar o gerenciador de pacotes ou distribuição não suportada."
    fi

    # Clonar o repositório do NeoVim e compilá-lo
    if ! git clone https://github.com/neovim/neovim.git; then
      error "Falha ao clonar o repositório do NeoVim."
    fi

    cd neovim

    # Opcionalmente, você pode especificar uma versão/tag específica do NeoVim usando o comando abaixo:
    # git checkout vX.Y.Z

    make CMAKE_BUILD_TYPE=Release
    sudo make install

    # Verificar a versão do NeoVim após a instalação
    if command -v nvim &>/dev/null && [[ "$(nvim --version | awk 'NR==1 {print $2}')" >= "$required_version" ]]; then
        echo "NeoVim instalado com sucesso a partir do código-fonte com uma versão superior a 0.9.0."
        custom_nvim_config
    else
      error "Falha ao instalar o NeoVim a partir do código-fonte com uma versão superior a 0.9.0."
    fi

    # Limpeza
    cd ..
    rm -rf neovim
}

function install_neovim(){
  PACKAGE_MANAGER="$1"
  # Verificar se o NeoVim está instalado
  if command -v nvim &>/dev/null; then
    installed_version=$(nvim --version | awk 'NR==1 {print $2}')
    required_version="0.9.0"

    if [[ "$installed_version" < "$required_version" ]]; then
      install_nvim_from_source
    else
      echo "NeoVim está instalado com uma versão superior a 0.9.0."
      custom_nvim_config  
    fi
  else
    echo "NeoVim não está instalado no sistema."
  fi
}

