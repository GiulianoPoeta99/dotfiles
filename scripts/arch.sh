#!/bin/bash

###########################################
# Arch Linux Installation Functions
###########################################
install_arch() {
  print_colored "blue" "Starting Arch Linux installation..."

  # System update and locale configuration
  sudo pacman -Syu
  local machine_lang=$(get_input "Is the machine configured in English? (Y/N): " "$VALID_YES_NO")
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
  print_colored "yellow" "Installing AUR..."
  (
    cd "$REPOS_DIR"
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin
    makepkg -si
  )

  # Install BlackArch repository
  print_colored "yellow" "Adding package repository..."
  (
    cd "$REPOS_DIR"
    mkdir blackarch && cd blackarch
    curl -O https://blackarch.org/strap.sh
    chmod +x strap.sh && sudo ./strap.sh
  )

  configure_zsh_arch
  configure_docker_arch
  configure_neovim
  install_arch_packages
  configure_system_services_arch
}

configure_zsh_arch() {
  print_colored "blue" "Configuring Zsh..."

  # Install required packages
  sudo pacman -S --noconfirm zsh fzf zoxide nushell eza onefetch fastfetch bashtop xclip bat lazygit glow atuin
  paru -S --noconfirm lazydocker

  atuin import auto
  
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

configure_hyprland() {
  sudo pacman -S --noconfirm hyprland wofi waybar ttf-font-awesome
}

configure_neovim() {
  print_colored "blue" "Configuring Neovim..."
  sudo pacman -S --noconfirm neovim ripgrep fd python-pip python-pipx go php composer jdk21-openjdk lua luarocks
  paru -S --noconfirm rvm
  pipx install poetry
  cd ~/dotfiles/
  stow neovim
}

configure_docker_arch() {
  cd ~
  print_colored "blue" "Configuring Docker..."
  print_colored "yellow" "First download the last package from https://docs.docker.com/desktop/release-notes/"
  wget https://download.docker.com/linux/static/stable/x86_64/docker-27.3.1.tgz -qO- | tar xvfz - docker/docker --strip-components=1
  mv ./docker /usr/local/bin
  sudo pacman -U ./docker-desktop-x86_64.pkg.tar.zst
  systemctl --user start docker-desktop
  systemctl --user enable docker-desktop
  sudo usermod -aG docker $USER
}

install_arch_packages() {
  sudo pacman -S --noconfirm bash-completion man-db man-pages podman discord spotify-launcher just tokei kondo sd git-delta
  paru -S --noconfirm brave-bin zen-browser-bin

  cat <<EOF
[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    navigate = true
    dark = true
    # side-by-side = true
    line-numbers = true
    hyperlinks = true
    syntax-theme = gruvbox-dark

[merge]
    conflictstyle = zdiff3
EOF
}

configure_system_services_arch() {
  # Enable Bluetooth
  sudo systemctl enable bluetooth
  sudo systemctl start bluetooth

  # Configure printing services
  sudo pacman -S cups gutenprint foomatic-db foomatic-db-engine foomatic-db-nonfree hplip splix cups-pdf
  sudo systemctl enable cups.service
  sudo systemctl start cups.service
  sudo pacman -S system-config-printer
  sudo gpasswd -a ${USER} sys

  # Configure Avahi
  sudo pacman -S avahi nss-mdns
  sudo systemctl enable avahi-daemon
  sudo systemctl start avahi-daemon
}
