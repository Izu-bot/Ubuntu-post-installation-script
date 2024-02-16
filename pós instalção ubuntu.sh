#!/bin/bash

# Variáveis
flatpak_repo="ppa:flatpak/stable"
postgresql_repo="https://apt.postgresql.org/pub/repos/apt"
node_snap="node --classic"
rust_install_cmd="curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"

# Função para verificar o código de retorno
check_return_code() {
    if [ "$1" -ne 0 ]; then
        echo "Erro durante a execução. Saindo."
        exit 1
    fi
}

echo "Fazendo a instalação dos arquivos necessários"

# Att
sudo apt update
sudo apt upgrade -y
check_return_code $?

# Rep do flatpak
sudo add-apt-repository $flatpak_repo
sudo apt update
check_return_code $?

# Instalar o postgresql
sudo sh -c "echo 'deb $postgresql_repo \$(lsb_release -cs)-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update
sudo apt -y install postgresql
check_return_code $?

# Pacotes apt
sudo apt install -y flatpak default-jre default-jdk virtualbox kotlin build-essential git-all
check_return_code $?

# Pacotes snap
sudo snap install $node_snap
sudo snap install postman
sudo snap install ngrok
check_return_code $?

# Flatpak installs
flatpak install flathub com.discordapp.Discord
flatpak install flathub com.jetbrains.PyCharm-Community
flatpak install flathub com.spotify.Client
flatpak install flathub org.libreoffice.LibreOffice
flatpak install flathub org.gnome.Builder
flatpak install flathub org.gnome.Calendar
flatpak install flathub org.eclipse.Java
check_return_code $?

# Rust
eval $rust_install_cmd
check_return_code $?

echo -e "Pendente:\nAndroid-Studio\nIntellij\nVsCode\nEclipse\nGoogle\nFerramentas de DB Oracle\nConfig SSH github"
