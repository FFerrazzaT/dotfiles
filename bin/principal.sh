#!/bin/bash

# Verificar permissões de sudo
if [ "$EUID" -ne 0 ]; then
  echo "Este script requer privilégios de superusuário. Por favor, execute com 'sudo'."
  exit 1
fi

# Detectar o gerenciador de pacotes
if command -v dpkg &>/dev/null; then
  PACKAGE_MANAGER="apt-get"
elif command -v rpm &>/dev/null; then
  PACKAGE_MANAGER="dnf"
elif command -v pacman &>/dev/null; then
  PACKAGE_MANAGER="pacman"
elif command -v zypper &>/dev/null; then
  PACKAGE_MANAGER="zypper"
else
  echo "Não foi possível determinar o gerenciador de pacotes."
  exit 1
fi

# Carregar pacotes do arquivo de configuração
source ../conf/packages.conf

# Carrega scripts
source ../script/install_packages.sh #Instalador de pacotes Gerais
source ../script/install_tmux.sh #Verifica e instala a versao minima do tmux
source ../script/install_neovim.sh #Verifica e instala a versao minima do nvim

instalar_pacotes "$PACKAGE_MANAGER" "${PACOTES_FUNDAMENTAIS[@]}" "${PACOTES_OBRIGATORIOS[@]}" "${PACOTES_OPCIONAIS[@]}"
install_tmux "$PACKAGE_MANAGER"
install_neovim "$PACKAGE_MANAGER"

echo "Concluído."
