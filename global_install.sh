#!/bin/bash

# Função para detectar a distribuição Linux
detect_linux_distribution() {
  if [ -f "/etc/os-release" ]; then
    source "/etc/os-release"
    echo "$NAME"
  elif [ -f "/etc/lsb-release" ]; then
    source "/etc/lsb-release"
    echo "$DISTRIB_ID"
  elif [ -f "/etc/debian_version" ]; then
    echo "Debian"
  elif [ -f "/etc/redhat-release" ]; then
    echo "Red Hat"
  else
    echo "Distribuição não detectada."
    exit 1
  fi
}

# Função para verificar se um pacote está instalado
is_package_installed() {
  dpkg -s "$1" >/dev/null 2>&1 || rpm -q "$1" >/dev/null 2>&1
}

# Verificar qual distribuição Linux está sendo utilizada
distribution=$(detect_linux_distribution)
echo "Distribuição Linux: $distribution"

# Verificar e instalar pacotes se necessário
if [ "$distribution" == "CentOS" ] || [ "$distribution" == "Red Hat" ]; then
  if ! is_package_installed yum; then
    echo "Instalando o yum..."
    sudo dnf install -y yum
  fi
elif [ "$distribution" == "Ubuntu" ] || [ "$distribution" == "Debian" ]; then
  if ! is_package_installed apt; then
    echo "Instalando o apt..."
    sudo apt-get update && sudo apt-get install -y apt
  fi
fi

if ! is_package_installed curl; then
  echo "Instalando o curl..."
  sudo yum install -y curl || sudo apt-get install -y curl
fi

if ! is_package_installed git; then
  echo "Instalando o git..."
  sudo yum install -y git || sudo apt-get install -y git
fi

echo "Concluído."
