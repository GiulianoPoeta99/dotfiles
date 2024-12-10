# generales
alias c='clear'
alias rmrf="rm -rf"
alias docker-la-puta-que-te-pario="sudo route add -net 192.168.0.0/24 gw 192.168.150.126"
alias ff="fastfetch"
alias of="onefetch"
alias n="nvim"
alias vs="code ."
alias fzfd='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'

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

..() {
  local count=${1:-1}
  local dots=""
  
  for ((i = 0; i < count; i++)); do
    dots+=".."
    if [ $i -lt $((count - 1)) ]; then
      dots+="/"
    fi
  done
  
  cd $dots
}

# bat
if [ -x "$(command -v batcat)" ]; then
  alias bat='batcat'
fi


# **********************************************************************************************************************
source ~/.config/zsh/alias/update.zsh # update
source ~/.config/zsh/alias/list.zsh # ls 
source ~/.config/zsh/alias/docker.zsh # docker
source ~/.config/zsh/alias/git.zsh # git
source ~/.config/zsh/alias/copy.zsh # copy
source ~/.config/zsh/alias/pacman.zsh # pacman
