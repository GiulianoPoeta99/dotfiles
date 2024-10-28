#!/bin/bash

###########################################
# Ubuntu Installation Functions
###########################################
install_ubuntu() {
  print_colored "blue" "Starting Ubuntu installation..."

  # System update
  sudo apt update && sudo apt upgrade -y

  # Add additional repositories
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
  sudo apt update

  # Run installation functions
  install_ubuntu_packages
  configure_nix
  configure_zsh_ubuntu
  configure_docker_ubuntu
  configure_neovim
  install_nix_packages
  install_composer
  install_snap_packages
}

configure_zsh_ubuntu() {
  print_colored "blue" "Configuring Zsh..."

  # Install required packages
  sudo apt install -y zsh fzf
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
  sudo apt install -y pkg-config libssl-dev build-essential
  cargo install nu

  # Configure zoxide
  echo 'eval "$(zoxide init --cmd cd bash)"' >>~/.bashrc

  # Setup dotfiles
  git clone https://github.com/GiulianoPoeta99/dotfiles.git ~/dotfiles || print_colored "yellow" "Dotfiles already exist"
  sudo rm -f /etc/zsh/zshenv

  (
    cd ~/dotfiles/zsh
    sudo stow -t /etc etc
    cd ..
    stow zsh
  )

  # Install and configure additional tools
  curl -sS https://starship.rs/install.sh | sh

  # Configure fonts if not using WSL
  if [[ "$WSL" =~ ^[Nn]$ ]]; then
    install_nerd_font "$FONT_ZIP"
  else
    print_colored "blue" "Skipping font installation in WSL environment"
  fi

  # Set Zsh as default shell
  chsh -s $(which zsh)

  # Initialize Zsh history
  mkdir -p ~/.local/state/zsh
  touch ~/.local/state/zsh/history

  print_colored "green" "Zsh configuration completed"
}

configure_docker_ubuntu() {
  print_colored "blue" "Configuring Docker..."
  sudo apt update -y
  sudo apt install "$(basename "$DOCKER_PKG")"
  systemctl --user start docker-desktop
  systemctl --user enable docker-desktop
  sudo usermod -aG docker $USER
}

install_ubuntu_packages() {
  sudo apt install -y neovim ripgrep fd-find python3.12-venv xclip bash-completion eza \
    bat glow man-db python3-pip podman golang-go php php-cli openjdk-21-jdk lua5.4 \
    luarocks
}

install_nix_packages() {
  nix-env -iA nixpkgs.lazygit nixpkgs.lazydocker nixpkgs.xdg-ninja nixpkgs.fzf
}

install_composer() {
  curl -sS https://getcomposer.org/installer -o composer-setup.php
  HASH=$(curl -sS https://composer.github.io/installer.sig)
  php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
  sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
  rm composer-setup.php
}

install_snap_packages() {
  sudo snap install brave slack obsidian --classic
}
