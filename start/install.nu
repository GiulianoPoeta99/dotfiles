#!/usr/bin/env nu

# === Actualizar sistema ===

def update-system [] {
  print "Actualizando Arch Linux..."
  sudo pacman -Syu --noconfirm

  print "Actualizando lista de mirrors..."
  sudo pacman -S --noconfirm reflector
  sudo reflector --verbose --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
  print "Actualización finalizada."
}

# === Instalar paquetes ===

def install-packages [] {
  # Verificar e instalar paru si no está presente
  if (which paru | is-empty) {
    print "'paru' no está instalado. Procediendo con la instalación..."
    mkdir ~/.repositories
    cd ~/.repositories
    git clone https://aur.archlinux.org/paru-bin.git
    cd paru-bin
    makepkg -si --noconfirm
    cd ~
  } else {
    print "'paru' ya está instalado."
  }

  # --- Instalar base ---
  print "Instalando paquetes base..."
  sudo pacman -S --noconfirm bash-completion man-db man-pages xclip stow glow
  paru -S --noconfirm ttf-cascadia-code-nerd

  # --- Instalar dev ---
  print "Instalando herramientas de desarrollo..."
  sudo pacman -S --noconfirm neovim ripgrep fd lazygit zsh nushell tmux starship fzf zoxide eza onefetch fastfetch bashtop bat atuin thefuck tokei kondo sd atac sshs age
  sudo pacman -S --noconfirm docker-desktop podman python python-pip python-pipx go php composer jdk24-openjdk maven gradle lua luarocks zig nim crystal shards dart clang just
  paru -S --noconfirm lazydocker tmuxinator portal-bin flutter gleam rvm

  # --- Instalar apps ---
  print "Instalando aplicaciones..."
  sudo pacman -S --noconfirm discord spotify-launcher
  paru -S --noconfirm brave-bin zen-browser-bin visual-studio-code-bin cursor-bin windsurf

  # --- Instalar entorno de escritorio ---
  print "Instalando entorno de escritorio..."
  sudo pacman -S --noconfirm hyprland
  paru -S --noconfirm hyprshot hyprlock hypridle hyprpaper hyprpicker hyprpolkitagent aylurs-gtk-shell eww

  # --- Instalar servicios del sistema ---
  print "Instalando servicios del sistema..."
  sudo pacman -S --noconfirm cups gutenprint foomatic-db foomatic-db-engine foomatic-db-nonfree hplip splix cups-pdf system-config-printer avahi nss-mdns

  # --- Instalar paquetes de Python globales ---
  print "Instalando paquetes de Python con pipx..."
  pipx install poetry
  pipx install uv

  # --- Instalar Rust ---
  print "Instalando Rust..."
  bash -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
  bash -c "source ~/.cargo/env"
  bash -c "rustup update"

  # --- Instalar paquetes cargo ---
  cargo install --locked dysk

  # --- Instalar Node.js y herramientas ---
  print "Instalando Node.js con NVM y Corepack..."
  bash -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash"
  bash -c "source ~/.nvm/nvm.sh"
  bash -c "nvm install 22"
  bash -c "corepack enable pnpm"
  bash -c "corepack enable yarn"

  # --- Instalar Nix determinate ---
  bash -c "curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate"

  # --- Instalar homebrew ---
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # --- Instalar paquetes de brew ---
  # go install github.com/yassinebenaid/bunster/cmd/bunster@latest
  brew install bunster

  # --- Instalar Lima ---
  brew install lima

  # --- Instalar JJ ---
  # cargo install --locked --bin jj jj-cli
  pacman -S jujutsu

  # --- Instalar carapace ---
  paru -S carapace

  # --- Instalar cosas de textual ---
  pipx install posting
  # pipx install dolphie
  brew install dolphie
  # pipx install harlequin
  brew install harlequin

}

# === Configurar servicios ===

def configure-services [] {
  print "Configurando servicios..."
  sudo systemctl enable bluetooth
  sudo systemctl start bluetooth
  sudo systemctl enable cups.service
  sudo systemctl start cups.service
  sudo systemctl enable avahi-daemon
  sudo systemctl start avahi-daemon
  gpasswd -a (whoami) sys
}

# === Configurar dotfiles ===

def configure-dotfiles [] {
  print "Configurando dotfiles..."
  let git_name = (input "Ingrese su nombre para la configuración de Git: ")
  let git_email = (input "Ingrese su correo para la configuración de Git: ")

  git config --global user.name $git_name
  git config --global user.email $git_email
  git config --global core.editor "vim"
  git config --global credential.helper "store"
  git config --global color.status.changed "yellow"
  git config --global init.defaultBranch "main"

  cd ~/.repositories/dotfiles
  sudo rm -f /etc/zsh/zshenv
  cd shell
  sudo stow -t /etc etc
  cd ..
  stow .
  mkdir ~/.local/state/zsh
  touch ~/.local/state/zsh/history
  chsh -s (which zsh)
  atuin import auto
}

# === Ejecutar todo ===

update-system
install-packages
configure-services
configure-dotfiles

print "Instalación completada."
