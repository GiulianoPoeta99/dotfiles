#!/bin/bash

set -e

# Global variables
REPOS_DIR=""
GIT_NAME=""
GIT_EMAIL=""
DISTRO=""
WSL=""
NIX=""

# Function to print colored output
print_colored() {
    local color=$1
    local message=$2
    case $color in
        "red") echo -e "\e[31m$message\e[0m" ;;
        "green") echo -e "\e[32m$message\e[0m" ;;
        "yellow") echo -e "\e[33m$message\e[0m" ;;
        "blue") echo -e "\e[34m$message\e[0m" ;;
        *) echo "$message" ;;
    esac
}

# Function to get user input with validation
get_input() {
    local prompt=$1
    local valid_options=$2
    local response

    while true; do
        read -p "$prompt" response
        if [[ -z "$valid_options" || "$response" =~ ^($valid_options)$ ]]; then
            echo "$response"
            return
        fi
        print_colored "red" "Invalid input. Please try again."
    done
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Initialize script
init_script() {
    print_colored "blue" "Starting installation..."
    print_colored "yellow" "Remember to download FiraCode Nerd Font and place the compressed file in the Downloads folder."

    WSL=$(get_input "Are you using WSL? (Y/N): " "Y|N|y|n")
    DISTRO=$(get_input "Choose your distribution (arch/ubuntu): " "arch|ubuntu")
    REPOS_DIR=$(get_input "Enter the directory for repositories: ")
    mkdir -p "$REPOS_DIR"
}

# Configure Git
configure_git() {
    print_colored "blue" "Configuring Git..."
    if [[ "$DISTRO" == "arch" ]]; then
        sudo pacman -S --noconfirm git
    elif [[ "$DISTRO" == "ubuntu" ]]; then
        sudo apt update && sudo apt install -y git
    fi

    GIT_NAME=$(get_input "Enter your Git username: ")
    GIT_EMAIL=$(get_input "Enter your Git email: ")

    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
    git config --global core.editor "vim"
    git config --global credential.helper store
    git config --global color.status.changed yellow
    git config --global init.defaultBranch "main"
}

# Configure Nix
configure_nix() {
    print_colored "blue" "Configuring Nix..."
    if [[ "$DISTRO" == "ubuntu" || $(get_input "Do you want to use Nix? (Y/N): " "Y|N|y|n") =~ ^[Yy]$ ]]; then
        sh <(curl -L https://nixos.org/nix/install) --daemon
    fi
}

# Configure Zsh
configure_zsh() {
    print_colored "blue" "Configuring Zsh..."
    if [[ "$DISTRO" == "arch" ]]; then
        sudo pacman -S --noconfirm zsh fzf zoxide
    elif [[ "$DISTRO" == "ubuntu" ]]; then
        sudo apt install -y zsh fzf
    fi

    git clone https://github.com/GiulianoPoeta99/dotfiles.git ~/dotfiles
    sudo rm /etc/zsh/zshenv

    (
        cd ~/dotfiles/zsh
        sudo stow -t /etc etc
        cd ..
        stow zsh
    )

    curl -sS https://starship.rs/install.sh | sh

    if [[ "$WSL" =~ ^[Nn]$ ]]; then
        mkdir -p ~/.local/share/fonts/nerd-fonts
        cp ~/Downloads/FiraCode.zip ~
        unzip FiraCode.zip && rm FiraCode.zip
        fc-match FiraCodeNerdFont -a
    fi

    chsh -s $(which zsh)
}

# Arch-specific installation
install_arch() {
    print_colored "blue" "Starting Arch Linux installation..."

    # Update system
    sudo pacman -Syu

    # Configure locale
    local machine_lang=$(get_input "Is the machine configured in English? (Y/N): " "Y|N|y|n")
    if [[ "$machine_lang" =~ ^[Nn]$ ]]; then
        sudo nano /etc/locale.gen
        sudo locale-gen
    fi

    # Configure pacman
    print_colored "yellow" "Add the following configuration to /etc/pacman.conf:"
    cat << EOF
# Misc options
#UseSyslog
Color
#NoProgressBar
CheckSpace
VerbosePkgLists
ParallelDownloads = 10
ILoveCandy
EOF

    read -p "Press Enter to continue after editing pacman.conf"
    sudo nano /etc/pacman.conf

    # Install AUR helper
    (
        cd "$REPOS_DIR"
        git clone https://aur.archlinux.org/paru-bin.git
        cd paru-bin
        makepkg -si
    )

    # Install BlackArch repository
    (
        cd "$REPOS_DIR"
        mkdir blackarch && cd blackarch
        curl -O https://blackarch.org/strap.sh
        chmod +x strap.sh && sudo ./strap.sh
    )

    # Install additional packages
    sudo pacman -S --noconfirm neovim ripgrep lazygit fd xclip bash-completion eza bat glow man-db man-pages docker docker-compose python-pip flatpak podman go php composer jdk22-openjdk lua luarocks
    paru -S --noconfirm lazydocker

    # Install Flatpak applications
    sudo flatpak install flathub com.brave.Browser com.slack.Slack md.obsidian.Obsidian

    configure_neovim
}

# Ubuntu-specific installation
install_ubuntu() {
    print_colored "blue" "Starting Ubuntu installation..."

    # Update system
    sudo apt update && sudo apt upgrade -y

    # Install additional repositories
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list

    # Docker installation
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update

    # Install packages
    sudo apt install -y neovim ripgrep fd-find python3.12-venv xclip bash-completion eza bat glow man-db docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin python3-pip podman golang-go php php-cli openjdk-21-jdk lua5.4 luarocks

    # Install Nix packages
    nix-env -iA nixpkgs.lazygit nixpkgs.lazydocker nixpkgs.xdg-ninja nixpkgs.fzf

    # Install Composer
    curl -sS https://getcomposer.org/installer -o composer-setup.php
    HASH=$(curl -sS https://composer.github.io/installer.sig)
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
    rm composer-setup.php

    # Install Snap applications
    sudo snap install brave slack obsidian --classic

    configure_neovim
}

# Configure Neovim
configure_neovim() {
    # Uncomment these lines if you want to reset your Neovim configuration
    # mv ~/.config/nvim{,.bak}
    # mv ~/.local/share/nvim{,.bak}
    # mv ~/.local/state/nvim{,.bak}
    # mv ~/.cache/nvim{,.bak}
    # git clone https://github.com/LazyVim/starter ~/.config/nvim
    # rm -rf ~/.config/nvim/.git
}

# Install development tools
install_dev_tools() {
    print_colored "blue" "Installing development tools..."

    # Install zoxide
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    echo 'eval "$(zoxide init --cmd cd bash)"' >> ~/.bashrc

    # Install Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
    rustup update

    # Install NVM and Node.js
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install 22
}

# Main function
main() {
    init_script
    configure_git
    configure_nix
    configure_zsh

    if [[ "$DISTRO" == "arch" ]]; then
        install_arch
    elif [[ "$DISTRO" == "ubuntu" ]]; then
        install_ubuntu
    else
        print_colored "red" "Unsupported distribution. Exiting."
        exit 1
    fi

    install_dev_tools

    print_colored "green" "Installation completed successfully!"
}

main
