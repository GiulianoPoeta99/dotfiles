###########################################
# AUR SETUP
###########################################
setup_aur() {
  print_colored "yellow" "Setting up AUR..."

  # Install AUR helper
  (
    cd ~/.repositories
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin
    makepkg -si
  )

  # Add BlackArch repository
  (
    cd ~/.repositories
    mkdir -p blackarch && cd blackarch
    curl -O https://blackarch.org/strap.sh
    chmod +x strap.sh && sudo ./strap.sh
  )

  print_colored "green" "AUR setup completed."
}

###########################################
# ALL INSTALLATIONS
###########################################
install_all() {
  print_colored "blue" "Installing all packages and tools..."

  sudo pacman -S --noconfirm \
    bash-completion man-db man-pages xclip stow reflector \
    neovim ripgrep fd python python-pip python-pipx \
    go rustup php composer jdk23-openjdk maven gradle \
    lua luarocks zig nim crystal shards dart pnpm yarn \
    zsh fzf zoxide nushell tmux starship eza onefetch \
    fastfetch bashtop bat lazygit glow atuin thefuck \
    podman discord spotify-launcher just tokei kondo \
    sd telegram-desktop cups gutenprint foomatic-db \
    foomatic-db-engine foomatic-db-nonfree hplip splix \
    cups-pdf system-config-printer avahi nss-mdns hyprland

  # AUR packages
  paru -S --noconfirm \
    brave-bin zen-browser-bin \ # whatsapp-for-linux \
    lazydocker tmuxinator ttf-cascadia-code-nerd \
    gleam flutter rvm nvm visual-studio-code-bin \
    hyprshot hyprlock hypridle hyprpaper hyprpicker \
    hyprpolkitagent aylurs-gtk-shell

  # Update mirrors
  sudo reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

  # Python tools
  pipx install poetry
  pipx install uv

  # Rust
  # curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  source $HOME/.cargo/env
  rustup update

  # Node.js
  # curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  # export NVM_DIR="$HOME/.nvm"
  # [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install 22

  # Docker
  wget https://download.docker.com/linux/static/stable/x86_64/docker-27.3.1.tgz -qO- | tar xvfz - docker/docker --strip-components=1
  sudo mv ./docker /usr/local/bin
  sudo pacman -U ./docker-desktop-x86_64.pkg.tar.zst
  systemctl --user start docker-desktop
  systemctl --user enable docker-desktop
  sudo usermod -aG docker $USER

  print_colored "green" "All installations completed."
}

###########################################
# SYSTEM SERVICES CONFIGURATION
###########################################
configure_system_services() {
  print_colored "blue" "Configuring system services..."

  # Bluetooth
  sudo systemctl enable bluetooth
  sudo systemctl start bluetooth

  # Printing
  sudo systemctl enable cups.service
  sudo systemctl start cups.service
  sudo gpasswd -a ${USER} sys

  # Network discovery
  sudo systemctl enable avahi-daemon
  sudo systemctl start avahi-daemon
}

###########################################
# DOTFILES CONFIGURATION
###########################################
configure_dotfiles() {
  print_colored "blue" "Configuring dotfiles..."

  cd ~/.repositories/dotfiles

  # Shell configuration
  sudo rm -f /etc/zsh/zshenv
  (
    cd shell
    sudo stow -t /etc etc
    cd ..
    stow shell
  )

  # Other configurations
  stow neovim
  stow hyprland

  # Shell setup
  mkdir -p ~/.local/state/zsh
  touch ~/.local/state/zsh/history
  chsh -s $(which zsh)
  atuin import auto

  # Install fonts if not in WSL
  if [[ "$WSL" =~ ^[Nn]$ ]]; then
    paru -S --noconfirm ttf-cascadia-code-nerd
  fi
}

###########################################
# MAIN ARCH FUNCTION
###########################################
main_arch() {
  print_colored "blue" "Starting Arch Linux installation..."

  # System configuration
  print_colored "yellow" "Add the following configuration to /etc/pacman.conf:"
  CONFIG_TEXT=$(
    cat <<EOF
# Misc options
Color
CheckSpace
VerbosePkgLists
ParallelDownloads = 10
ILoveCandy
EOF
  )
  echo "The next fragment was copied to clipboard"
  echo "$CONFIG_TEXT" | xclip -selection clipboard
  read -p "Press Enter to continue after editing pacman.conf"

  # Language configuration
  print_colored "yellow" "Fixing language..."
  local machine_lang=$(get_input "Is the machine configured in English? (Y/N): " "$VALID_YES_NO")
  if [[ "$machine_lang" =~ ^[Nn]$ ]]; then
    echo "Uncomment the en_US.UTF-8."
    read -p "Press Enter to continue after editing locale.gen"
    sudo nano /etc/locale.gen
    sudo locale-gen
  fi

  # Installation and configuration sequence
  setup_aur
  install_all
  configure_system_services
  configure_dotfiles
  configure_git

  print_colored "green" "Arch Linux installation and configuration completed."
}
