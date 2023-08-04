#!/usr/bin/env bash

BIN_INSTALL_DIR="/usr/local/bin"

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
  elif [ -f "/etc/arch-release" ]; then
    echo "Arch Linux"
  else
    echo "Distribuição não detectada."
    exit 1
  fi
}

# Verificar qual distribuição Linux está sendo utilizada
distribution=$(detect_linux_distribution)
echo "Distribuição Linux: $distribution"

sudo install -d -m 755 $BIN_INSTALL_DIR
install -d -m 755 $DATA_INSTALL_DIR
