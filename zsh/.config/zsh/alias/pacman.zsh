pac() {
  case "$1" in
    install)
      shift
      sudo pacman -S "$@"
      ;;
    update)
      sudo pacman -Syu
      ;;
    remove)
      shift
      sudo pacman -R "$@"
      ;;
    autoremove)
      shift
      sudo pacman -Rns "$@"
      ;;
    search)
      shift
      pacman -Ss "$@"
      ;;
    show)
      shift
      pacman -Si "$@"
      ;;
    list)
      shift
      pacman -Qs "$@"
      ;;
    clean)
      sudo pacman -Sc
      ;;
    full-upgrade)
      sudo pacman -Syyu
      ;;
    *)
      echo "Comando no reconocido: $1"
      ;;
  esac
}
