#!/bin/bash

# Função para instalar pacotes
function check_and_install_package() {
  local package_name=$1
  if ! command -v "$package_name" &>/dev/null; then
    echo "Instalando $package_name..."
    sudo "$PACKAGE_MANAGER" install -y "$package_name" || echo "Erro ao instalar o pacote $package_name."
  else
    echo "$package_name já está instalado."
  fi
}

# Função para perguntar ao usuário se ele deseja instalar o pacote
function ask_to_install_package() {
  local package_name=$1
  read -p "Deseja instalar $package_name? (yes/no): " install
  if [ "$install" == "yes" ]; then
    check_and_install_package "$package"
  fi
}

function instalar_pacotes(){
    PACKAGE_MANAGER="$1"
    PACOTES_FUNDAMENTAIS=("${@:2:$#-3}")
    PACOTES_OBRIGATORIOS=("${@:$#-1}")
    PACOTES_OPCIONAIS=("${@:$#}")

    # Pacotes obrigatórios e fundamentais
    for package in "${PACOTES_FUNDAMENTAIS[@]}" "${PACOTES_OBRIGATORIOS[@]}"; do
    check_and_install_package "$package"
    done

    # Pacotes opcionais
    for package in "${PACOTES_OPCIONAIS[@]}"; do
    ask_to_install_package "$package"
    done
}
