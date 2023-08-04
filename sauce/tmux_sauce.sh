#!/bin/bash

# Carrega o arquivo de configuração
CONFIG_FILE="../conf/config_sauce.conf"

function install_conf(){
    # Verifique se o arquivo de configuração personalizado existe
    if [ ! -f "$1" ]; then
        echo "O arquivo de configuração personalizado ($1) não foi encontrado."
        exit 1
    fi

    # Menu interativo para escolher o local
    echo "Escolha em qual dos seguintes locais a configuração personalizada do tmux será instalada:"
    for i in "${!LOCAIS_TMUX_CONF[@]}"; do
        echo "$((i + 1)) - ${LOCAIS_TMUX_CONF[$i]}"
    done

    read -p "Digite o número da opção desejada: " OPCAO

    # Instala o arquivo de configuração personalizado no local escolhido
    INDEX=$((OPCAO - 1))
    if [ "$INDEX" -ge 0 ] && [ "$INDEX" -lt "${#LOCAIS_TMUX_CONF[@]}" ]; then
        LOCAL_TMUX_CONF="${LOCAIS_TMUX_CONF[$INDEX]}"
        if [ ! -w "$LOCAL_TMUX_CONF" ]; then
            echo "O local escolhido ($LOCAL_TMUX_CONF) não é gravável. Não é possível instalar a configuração personalizada do tmux."
            exit 1
        fi

        # Instala o arquivo de configuração personalizado no local escolhido
        cp "$1" "$LOCAL_TMUX_CONF"
        echo "Configuração personalizada do tmux instalada em: $LOCAL_TMUX_CONF"
    else
        echo "Opção inválida. Saindo."
        exit 1
    fi
}

function tmux_sauce(){
    # Verifica se o tmux está instalado
    if ! command -v tmux &>/dev/null; then
        echo "O tmux não está instalado. Por favor, instale o tmux antes de continuar."
        exit 1
    fi
    
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
    else
        echo "O arquivo de configuração ($CONFIG_FILE) não foi encontrado."
        exit 1
    fi

    # Verifica o argumento fornecido para escolher a instalação
    if [ "$1" = "local" ]; then
        install_conf "${SAUCE_CONF_TMUX_LOCAL}"
    elif [ "$1" = "remoto" ]; then
        install_conf "${SAUCE_CONF_TMUX_REMOTO}"
    else
        echo "Escolha invalida"
        exit 1
    fi
}