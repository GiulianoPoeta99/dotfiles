def update [] {
   # Función para imprimir un separador dinámico
   def separator [] {
      let cols = (term size).columns
      0..($cols - 1) | each { print -n "=" }
      print "\n"
   }

   # Solicitar permisos con sudo al principio
   echo "Se necesita sudo para seguir:"
   sudo true
   echo ""

   # Buscar el administrador de paquetes y actualizar según el sistema
   if (which pacman | is-not-empty) {
      echo "Actualizando paquetes de base Arch"
      sudo pacman -Syu --noconfirm
      echo "Actualización de paquetes Arch completada"
      separator
   } else if (which nala | is-not-empty) {
      echo "Actualizando paquetes de base Debian (nala)"
      sudo nala update and sudo nala upgrade -y
      echo "Actualización de paquetes Debian completada"
      separator
   } else if (which apt | is-not-empty) {
      echo "Actualizando paquetes de base Debian"
      sudo apt update and sudo apt upgrade -y
      echo "Actualización de paquetes Debian completada"
      separator
   } else if (which zypper | is-not-empty) {
      echo "Actualizando paquetes de base openSUSE"
      sudo zypper refresh and sudo zypper update
      echo "Actualización de paquetes openSUSE completada"
      separator
   } else {
      echo "No se reconoce el administrador de paquetes. No se realizaron actualizaciones específicas."
      separator
   }

   # Actualizar AUR si es Arch Linux
   if (which yay | is-not-empty) {
      echo "Actualizando paquetes AUR"
      yay -Syu --noconfirm
      echo "Actualización de paquetes AUR completada"
      separator
   } else if (which paru | is-not-empty) {
      echo "Actualizando paquetes AUR"
      paru -Syu --noconfirm
      echo "Actualización de paquetes AUR completada"
      separator
   }

   # Actualizar otros gestores de paquetes
   if (which brew | is-not-empty) {
      echo "Actualizando paquetes de Homebrew"
      brew update and brew upgrade
      echo "Actualización de paquetes Homebrew completada"
      separator
   }

   if (which flatpak | is-not-empty) {
      echo "Actualizando paquetes de Flatpak"
      sudo flatpak update -y
      echo "Actualización de paquetes Flatpak completada"
      separator
   }

   if (which snap | is-not-empty) {
      echo "Actualizando paquetes de Snap"
      sudo snap refresh
      echo "Actualización de paquetes Snap completada"
      separator
   }

   if (which nix-channel | is-not-empty) {
      echo "Actualizando paquetes de Nix"
      nix-channel --update
      nix-env -u
      echo "Actualización de paquetes Nix completada"
      separator
   }

   echo "Se actualizaron todos los paquetes."
}
