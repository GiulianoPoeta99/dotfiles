#!/bin/bash

# Elegimos una distro para hacer la instalación
echo "Elija su distribución (arch/ubuntu):"
read DISTRO

# Verificamos que se haya ingresado una distro válida
if [[ "$DISTRO" != "arch" && "$DISTRO" != "ubuntu" ]]; then
    echo "Distribución no válida. Debe ser 'arch' o 'ubuntu'."
    exit 1
fi

# ######################################################################################################################
# Para cualquier distro

# Instalamos nix =======================================================================================================
sh <(curl -L https://nixos.org/nix/install) --daemon

# Creamos carpeta de repos de sistema centrales ========================================================================
echo "Ingrese el directorio para repositorios:"
read REPOS_DIR

mkdir -p "$REPOS_DIR"

# Instalamos y configuramos git ========================================================================================
if [[ "$DISTRO" == "arch" ]]; then
    sudo pacman -S --noconfirm git
elif [[ "$DISTRO" == "ubuntu" ]]; then
    sudo apt update
    sudo apt install -y git
fi

echo "Ingrese su nombre de usuario de git:"
read GIT_NAME

echo "Ingrese su email de git:"
read GIT_EMAIL

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global core.editor "vim"
git config --global credential.helper store
git config --global color.status.changed yellow

# Instalamos zsh =======================================================================================================
if [[ "$DISTRO" == "arch" ]]; then
    sudo pacman -S --noconfirm zsh
elif [[ "$DISTRO" == "ubuntu" ]]; then
    sudo apt install -y zsh
fi

cd
git clone https://github.com/GiulianoPoeta99/dotfiles.git

sudo rm /etc/zsh/zshenv
mkdir .config/zsh/
ln -s /home/$USER/$CODE_DIR/projects/dotfiles/zsh/dotfiles/.zshrc ~/.config/zsh/.zshrc
ln -s /home/$USER/$CODE_DIR/projects/dotfiles/zsh/dotfiles/alias ~/.config/zsh/
mkdir -p .local/state/zsh

mkdir -p "$REPOS_DIR/zsh"
cd "$REPOS_DIR/zsh"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/ohmyzsh/ohmyzsh.git # instalamos paquetes varios

curl -sS https://starship.rs/install.sh | sh

cd && mkdir -p .local/share/fonts/nerd-fonts 

cp ~/Downloads/FiraCode.zip .

unzip FiraCode.zip && rm FiraCode.zip

fc-match FiraCodeNerdFont -a

chsh -s $(which zsh)

cd

# # Instalamos wezterm =================================================================================================


# Instalamos nvim y lazyvim ============================================================================================

if [[ "$DISTRO" == "arch" ]]; then
    sudo pacman -S --noconfirm neovim lazygit ripgrep fd
elif [[ "$DISTRO" == "ubuntu" ]]; then
    sudo apt install -y neovim ripgrep fd-find python3.12-venv
    nix-env -iA nixpkgs.lazygit
fi

# mv ~/.config/nvim{,.bak}
# mv ~/.local/share/nvim{,.bak}
# mv ~/.local/state/nvim{,.bak}
# mv ~/.cache/nvim{,.bak}

# git clone https://github.com/LazyVim/starter ~/.config/nvim

# rm -rf ~/.config/nvim/.git

# Instalamos awesome wm ================================================================================================


# Instalamos paquetes varios ===========================================================================================
if [[ "$DISTRO" == "arch" ]]; then
    # instalamos paquetes varios de pacman =============================================================================
    sudo pacman -S --noconfirm fzf xclip bash-completion eza bat glow man-db \
        man-pages docker docker-compose python-pip flatpak podman go php composer \
        jdk22-openjdk lua luarocks
    # instalamos paquetes varios de AUR ================================================================================
    paru -S --noconfirm xdg-ninja lazydocker

    # instalamos paquetes varios de flatpak ============================================================================
    sudo flatpak install flathub com.brave.Browser
    sudo flatpak install flathub com.slack.Slack
    sudo flatpak install flathub md.obsidian.Obsidian
elif [[ "$DISTRO" == "ubuntu" ]]; then
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
    sudo apt update

    # preparamos instalación de docker =================================================================================
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install 

    # instalamos paquetes varios de apt ================================================================================
    sudo apt install -y xclip bash-completion eza bat glow man-db \
        docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
        python3-pip podman golang-go php php-cli openjdk-21-jdk lua5.4 luarocks

    # instalamos paquetes varios de nix ================================================================================
    nix-env -iA nixpkgs.lazydocker
    nix-env -iA nixpkgs.xdg-ninja
    nix-env -iA nixpkgs.fzf

    # instalamos composer ==============================================================================================
    cd ~
    curl -sS https://getcomposer.org/installer -o composer-setup.php
    HASH=`curl -sS https://composer.github.io/installer.sig`
    echo $HASH
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

    # instalamos paquetes varios de snap ===============================================================================
    sudo snap install brave
    sudo snap install slack
    sudo snap install obsidian --classic
fi

# instalamos zoxide ====================================================================================================
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
echo 'eval "$(zoxide init --cmd cd bash)"' >> ~/.bashrc

# instalamos rustup y rust =============================================================================================
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup update

# instalamos nvm y npm =================================================================================================
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
nvm install 22

# ######################################################################################################################
# Para arch
if [[ "$DISTRO" == "arch" ]]; then
    # Actualizamos los repos y paquetes ================================================================================
    sudo pacman -Syu

    # Configuramos idioma de la maquina ================================================================================
    echo "¿La máquina está configurada en inglés? (s/n):"
    read MACHINE_LANG
    if [[ "$MACHINE_LANG" == "n" ]]; then
        sudo nano /etc/locale.gen
        sudo locale-gen
    fi

    # Configuramos pacman ==============================================================================================
    # TODO: hacer que lo copie al buffer y abrir vim o nano

    echo "Agregue la siguiente configuración a /etc/pacman.conf:"
    echo "# Misc options"
    echo "#UseSyslog"
    echo "Color"
    echo "#NoProgressBar"
    echo "CheckSpace"
    echo "VerbosePkgLists"
    echo "ParallelDownloads = 10"
    echo "ILoveCandy"

    read -p "Presione Enter para continuar después de editar pacman.conf"
    sudo nano /etc/pacman.conf

    # Instalamos AUR ===================================================================================================
    cd && cd "$REPOS_DIR"
    git clone https://aur.archlinux.org/paru-bin.git && cd paru-bin
    makepkg -si

    # Instalamos repo de blackarch =====================================================================================
    cd ..
    mkdir blackarch && cd blackarch
    curl -O https://blackarch.org/strap.sh
    chmod +x strap.sh && sudo ./strap.sh

    # Acutalizamos los repos nuevamente ================================================================================
    sudo pacman -Syu && cd
fi