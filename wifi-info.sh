#!/bin/bash

# Verifica dependências e solicita autorização para instalá-las
function check_dependencies() {
    echo "Verificando dependências necessárias..."
    dependencies=("figlet" "arp-scan" "nmap" "speedtest-cli")
    missing=()

    # Verifica quais dependências estão faltando
    for pkg in "${dependencies[@]}"; do
        if ! command -v $pkg &>/dev/null; then
            missing+=($pkg)
        fi
    done

    # Se houver dependências faltando, pergunta ao usuário
    if [ ${#missing[@]} -ne 0 ]; then
        echo "As seguintes ferramentas são necessárias: ${missing[*]}"
        read -p "Deseja instalar todas automaticamente? (s/n): " choice
        if [[ "$choice" =~ ^[Ss]$ ]]; then
            for pkg in "${missing[@]}"; do
                echo "Instalando $pkg..."
                pkg install -y $pkg
            done
        else
            echo "Dependências não instaladas. Saindo do script."
            exit 1
        fi
    else
        echo "Todas as dependências já estão instaladas."
    fi
}

# Painel com título estilizado
function display_title() {
    clear
    echo -e "\e[32m"  # Define a cor verde
    figlet "WiFi_Info"
    echo -e "\e[0m"   # Restaura a cor padrão
    echo "============================================"
    echo " Ferramenta de Monitoramento de Redes - Termux"
    echo "============================================"
}

# Exibe informações da rede conectada
function network_info() {
    echo -e "\nInformações da Rede Conectada:"
    echo "--------------------------------"
    ssid=$(iwgetid -r)
    ip=$(ip -4 addr show wlan0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    gateway=$(ip route | grep default | awk '{print $3}')
    echo "SSID: $ssid"
    echo "IP: $ip"
    echo "Gateway: $gateway"
    echo "--------------------------------"
}

# Descobre dispositivos na rede
function scan_network() {
    echo -e "\nDispositivos Conectados:"
    echo "--------------------------------"
    arp-scan --localnet | grep -v "Interface"
    echo "--------------------------------"
}

# Realiza teste de velocidade
function speed_test() {
    echo -e "\nTeste de Velocidade:"
    echo "--------------------------------"
    speedtest-cli --simple
    echo "--------------------------------"
}

# Menu principal
function main_menu() {
    display_title
    network_info
    scan_network
    speed_test
}

# Executa o script
check_dependencies
main_menu
