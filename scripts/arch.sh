###########################################
# SERVICES CONFIG
###########################################
configure_services() {
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

  yay -S evdi
  yay -S displaylink

  sudo modprobe evdi

  sudo systemctl enable displaylink.service
  sudo systemctl start displaylink.service
}

###########################################
# GIT CONFIG
###########################################
configure_git() {
  print_colored "blue" "Configuring Git..."

  pacman -S --noconfirm git

  # Configure Git settings
  GIT_NAME=$(get_input "Enter your Git username: ")
  GIT_EMAIL=$(get_input "Enter your Git email: ")

  git config --global user.name "$GIT_NAME"
  git config --global user.email "$GIT_EMAIL"
  git config --global core.editor "vim"
  git config --global credential.helper store
  git config --global color.status.changed yellow
  git config --global init.defaultBranch "main"
}

###########################################
# PACKAGES CONFIG
###########################################
configure_aur() {
  print_colored "yellow" "Installing AUR..."
  (
    cd "$REPOS_DIR"
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin
    makepkg -si
  )
}

configure_repos() {
  print_colored "yellow" "Adding package repository..."
  (
    cd "$REPOS_DIR"
    mkdir blackarch && cd blackarch
    curl -O https://blackarch.org/strap.sh
    chmod +x strap.sh && sudo ./strap.sh
  )
}

install_packages() {
  sudo pacman -S --noconfirm bash-completion man-db man-pages podman discord spotify-launcher just tokei kondo sd telegram-desktop
  paru -S --noconfirm brave-bin zen-browser-bin whatsapp-for-linux
}

###########################################
# NF CONFIG
###########################################
install_nerd_font() {
  local font_zip="$1"
  local font_name=$(basename "$font_zip" .zip)

  print_colored "blue" "Installing Nerd Font: $font_name"

  local font_dir="$HOME/.local/share/fonts/nerd-fonts"
  mkdir -p "$font_dir"

  cd "$font_dir"
  cp "$font_zip" .
  unzip -o "$(basename "$font_zip")"
  rm "$(basename "$font_zip")"

  fc-cache -fv

  local font_pattern="${font_name//-/ }"
  print_colored "blue" "Checking font installation for: $font_pattern"

  if fc-list | grep -i "$font_pattern" >/dev/null; then
    print_colored "green" "Font installed successfully"
    fc-match "$font_pattern" -a
  else
    print_colored "yellow" "Warning: Font might not be properly installed"
    print_colored "yellow" "Available similar fonts:"
    fc-list | grep -i "nerd" | cut -d: -f2 | sort | uniq
  fi

  print_colored "green" "Nerd Font configuration completed."
}

###########################################
# SHELL CONFIG
###########################################
configure_shell() {
  print_colored "blue" "Configuring shell..."

  sudo pacman -S --noconfirm zsh fzf zoxide nushell tmux eza onefetch fastfetch bashtop xclip bat lazygit glow atuin
  paru -S --noconfirm lazydocker tmuxinator

  atuin import auto

  sudo rm -f /etc/zsh/zshenv
  (
    cd $WORKING_DIR/shell
    sudo stow -t /etc etc
    cd ..
    stow --adopt shell
  )

  curl -sS https://starship.rs/install.sh | sh

  # Configure fonts if not using WSL
  if [[ "$WSL" =~ ^[Nn]$ ]]; then
    install_nerd_font "$FONT_ZIP"
  else
    print_colored "blue" "Skipping font installation in WSL environment"
  fi

  chsh -s $(which zsh)

  mkdir -p ~/.local/state/zsh
  touch ~/.local/state/zsh/history

  print_colored "green" "Zsh configuration completed."
}

###########################################
# NVIM CONFIG
###########################################
configure_neovim() {
  print_colored "blue" "Configuring Neovim..."

  sudo pacman -S --noconfirm neovim ripgrep fd \
    python-pip python-pipx \
    go \
    php composer \
    jdk21-openjdk \
    lua luarocks \
    ruby \
    zig \
    nim \
    crystal shards
  paru -S --noconfirm gleam

  pipx install poetry

  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  source $HOME/.cargo/env
  rustup update

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install 22

  cd $WORKING_DIR
  stow neovim
}

###########################################
# DOCKER CONFIG
###########################################
configure_docker() {
  cd ~
  print_colored "blue" "Configuring Docker..."
  wget https://download.docker.com/linux/static/stable/x86_64/docker-27.3.1.tgz -qO- | tar xvfz - docker/docker --strip-components=1
  mv ./docker /usr/local/bin
  sudo pacman -U ./docker-desktop-x86_64.pkg.tar.zst
  systemctl --user start docker-desktop
  systemctl --user enable docker-desktop
  sudo usermod -aG docker $USER
}

###########################################
# HYPRLAND CONFIG
###########################################
configure_hyprland() {
  sudo pacman -S --noconfirm hyprland wofi waybar
}

###########################################
# MAIN EXECUTION
###########################################
main_arch() {
  print_colored "blue" "Starting Arch Linux installation..."

  print_colored "yellow" "Update package system..."
  sudo pacman -Syu --noconfirm
  sudo pacman -S linux-lts-headers

  print_colored "green" "Enhancing package system..."
  sudo pacman -S --noconfirm xclip

  print_colored "yellow" "Add the following configuration to /etc/pacman.conf:"
  CONFIG_TEXT=$(
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
  )

  echo "$CONFIG_TEXT" | xclip -selection clipboard

  read -p "Press Enter to continue after editing pacman.conf"
  sudo nano /etc/pacman.conf

  print_colored "yellow" "Fixing language..."
  local machine_lang=$(get_input "Is the machine configured in English? (Y/N): " "$VALID_YES_NO")
  if [[ "$machine_lang" =~ ^[Nn]$ ]]; then
    sudo nano /etc/locale.gen
    sudo locale-gen
  fi

  configure_services
  configure_git
  configure_aur
  configure_repos
  install_packages

  print_colored "blue" "Installing stow..."
  sudo pacman -S --noconfirm stow
  configure_shell
  configure_neovim
  configure_docker
  configure_hyprland
}
