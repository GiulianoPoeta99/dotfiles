#!/bin/bash

set -e

# Global variables
REPOS_DIR=""
GIT_NAME=""
GIT_EMAIL=""
DISTRO=""
WSL=""
NIX=""
FONT_ZIP=""

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
  FONT_ZIP=$(get_input "Enter the path to the FiraCode Nerd Font ZIP file: ")

  # Check if the file exists
  if [[ ! -f "$FONT_ZIP" ]]; then
    print_colored "red" "File does not exist: $FONT_ZIP"
    exit 1
  fi

  WSL=$(get_input "Are you using WSL? (Y/N): " "Y|N|y|n")
  DISTRO=$(get_input "Choose your distribution (arch/ubuntu): " "arch|ubuntu")
  REPOS_DIR=$(get_input "Enter the directory for repositories: ")
  mkdir -p "$REPOS_DIR"
}

# Configure Git
configure_git() {
  print_colored "blue" "Configuring Git..."
  if [[ "$DISTRO" == "arch" ]]; then
    sudo pacman -Syu --noconfirm && pacman -S --noconfirm git
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
    sudo pacman -S --noconfirm zsh fzf zoxide nushell
  elif [[ "$DISTRO" == "ubuntu" ]]; then
    sudo apt install -y zsh fzf
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    sudo apt install -y pkg-config libssl-dev build-essential
    cargo install nu
  fi

  echo 'eval "$(zoxide init --cmd cd bash)"' >>~/.bashrc

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
    mkdir -p ~/.local/share/fonts/nerd-fonts && cd ~/.local/share/fonts/nerd-fonts
    cp "$FONT_ZIP" .
    unzip "$(basename "$FONT_ZIP")" && rm "$(basename "$FONT_ZIP")"
    fc-match FiraCodeNerdFont -a
  fi

  chsh -s $(which zsh)

  cd ~/.local/state
  mkdir zsh
  touch history
}

# Configure Docker
configure_docker() {
  print_colored "blue" "Configuring Docker..."

  if [[ "$DISTRO" == "arch" ]]; then
    sudo pacman -S --noconfirm docker
  elif [[ "$DISTRO" == "ubuntu" ]]; then
    sudo apt update -y
    sudo apt install "$(basename "$DOCKER_PKG")"
  fi

  # Enable and start Docker daemon
  systemctl --user start docker-desktop
  systemctl --user enable docker-desktop

  # Add user to Docker group
  sudo usermod -aG docker $USER

  print_colored "green" "Docker has been installed and configured. You may need to log out and back in for group changes to take effect."
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
  cat <<EOF
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
  sudo pacman -S --noconfirm neovim ripgrep lazygit fd xclip bash-completion eza bat \
    glow man-db man-pages python-pip podman go php composer jdk21-openjdk \
    lua luarocks obsidian discord fastfetch dbeaver spotify-launcher bashtop
  paru -S --noconfirm lazydocker brave-bin zen-browser-bin freeoffice

  # habilitar el bluetooth
  sudo systemctl enable bluetooth
  sudo systemctl start bluetooth

  # habilitar la impresion
  sudo pacman -S cups gutenprint foomatic-db foomatic-db-engine foomatic-db-nonfree hplip splix cups-pdf
  sudo systemctl enable cups.service
  sudo systemctl start cups.service
  sudo pacman -S system-config-printer
  sudo gpasswd -a ${USER} sys
  sudo pacman -S avahi nss-mdns
  sudo systemctl enable avahi-daemon
  sudo systemctl start avahi-daemon

  configure_docker
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

  sudo apt update

  # Install packages
  sudo apt install -y neovim ripgrep fd-find python3.12-venv xclip bash-completion eza \
    bat glow man-db python3-pip podman golang-go php php-cli openjdk-21-jdk lua5.4 \
    luarocks

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

  configure_docker
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
  install_dev_tools
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

  print_colored "green" "Installation completed successfully!"
}

main
