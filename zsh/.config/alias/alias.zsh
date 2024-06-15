# generales

# sudo
pls() {
    if command -v sudo &> /dev/null; then
        sudo "$@"
    elif command -v doas &> /dev/null; then
        doas "$@"
    else
        echo "Error: Ni sudo ni doas están instalados en el sistema."
    fi
}

# fzf 
alias fzfd='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'

# paru = yay
alias yay='paru'

cdup() {
  local count=${1:-1}
  local dots=""
  
  # Construir la cadena de puntos para cd..
  for ((i = 0; i < count; i++)); do
    dots+=".."
    if [ $i -lt $((count - 1)) ]; then
      dots+="/"
    fi
  done
  
  # Ejecutar el comando cd con la cadena construida
  cd $dots
}

if [ -x "$(command -v batcat)" ]; then
  alias bat='batcat'
fi


# ********************************************************************************************************************************************************
#
source /mnt/sda1/code/projects/dotfiles/zsh/dotfiles/alias/update.zsh # update
source /mnt/sda1/code/projects/dotfiles/zsh/dotfiles/alias/list.zsh # ls 
source /mnt/sda1/code/projects/dotfiles/zsh/dotfiles/alias/docker.zsh # docker
source /mnt/sda1/code/projects/dotfiles/zsh/dotfiles/alias/git.zsh # git
source /mnt/sda1/code/projects/dotfiles/zsh/dotfiles/alias/copy.zsh # copy
source /mnt/sda1/code/projects/dotfiles/zsh/dotfiles/alias/gpt.zsh # gpt