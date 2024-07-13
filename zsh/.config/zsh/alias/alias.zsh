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

..() {
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
source ~/.config/zsh/alias/update.zsh # update
source ~/.config/zsh/alias/list.zsh # ls 
source ~/.config/zsh/alias/docker.zsh # docker
source ~/.config/zsh/alias/git.zsh # git
source ~/.config/zsh/alias/copy.zsh # copy
source ~/.config/zsh/alias/gpt.zsh # gpt