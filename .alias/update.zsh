# update de todos los paquetes
update() {
    # Función para imprimir un separador dinámico
    separator() {
        local cols=$(tput cols)
        printf '%*s\n' "$cols" '' | tr ' ' '='
    }

    # Solicitar la contraseña con sudo al principio
    echo 'Se necesita sudo para seguir:'
    sudo -v
    echo ''

    # Buscar el administrador de paquetes
    if [ -x "$(command -v pacman)" ]; then
        # Arch Linux
        echo 'Actualizando paquetes de base Arch'
        echo ''
        sudo pacman -Syu --noconfirm
        echo ''
        echo 'Actualización de paquetes Arch completada'
        echo ''
        separator
    elif [ -x "$(command -v nala)" ]; then
        # Debian o Ubuntu con nala
        echo 'Actualizando paquetes de base Debian'
        echo ''
        sudo nala update && sudo nala upgrade -y
        echo ''
        echo 'Actualización de paquetes Debian completada'
        echo ''
        separator
    elif [ -x "$(command -v apt)" ]; then
        # Debian o Ubuntu
        echo 'Actualizando paquetes de base Debian'
        echo ''
        sudo apt update && sudo apt upgrade -y
        echo ''
        echo 'Actualización de paquetes Debian completada'
        echo ''
        separator
    elif [ -x "$(command -v zypper)" ]; then
        # openSUSE
        echo 'Actualizando paquetes de base openSUSE'
        echo ''
        sudo zypper refresh && sudo zypper update
        echo ''
        echo 'Actualización de paquetes openSUSE completada'
        echo ''
        separator
    else
        # No se reconoce el administrador de paquetes
        echo 'No se reconoce el administrador de paquetes. No se realizaron actualizaciones específicas.'
        echo ''
        separator
    fi

    echo ''

    # Verificar y ejecutar otros comandos si las herramientas están instaladas
    if [ -x "$(command -v yay)" ] || [ -x "$(command -v paru)" ]; then
        echo 'Actualizando paquetes AUR'
        echo ''
        if [ -x "$(command -v yay)" ]; then
            yay -Syu --noconfirm
        fi
        
        if [ -x "$(command -v paru)" ]; then
            paru -Syu --noconfirm
        fi
        echo ''
        echo 'Actualización de paquetes AUR completada'
        echo ''
        separator
        echo ''
    fi

    if [ -x "$(command -v brew)" ]; then
        echo 'Actualizando paquetes de Homebrew'
        echo ''
        brew update && brew upgrade
        echo ''
        echo 'Actualización de paquetes Homebrew completada'
        echo ''
        separator
        echo ''
    fi

    if [ -x "$(command -v flatpak)" ]; then
        echo 'Actualizando paquetes de Flatpak'
        echo ''
        sudo flatpak update -y
        echo ''
        echo 'Actualización de paquetes Flatpak completada'
        echo ''
        separator
        echo ''
    fi

    if [ -x "$(command -v snap)" ]; then
        echo 'Actualizando paquetes de Snap'
        echo ''
        sudo snap refresh
        echo ''
        echo 'Actualización de paquetes Snap completada'
        echo ''
        separator
        echo ''
    fi

    if [ -x "$(command -v nix-channel)" ]; then
        echo 'Actualizando paquetes de Nix'
        echo ''
        nix-channel --update
        nix-env -u 
        echo ''
        echo 'Actualización de paquetes Nix completada'
        echo ''
        separator
        echo ''
    fi
    echo 'Se actualizaron todos los paquetes.'
}