# generales
alias c='clear'
alias rmrf="rm -rf"
alias docker-la-puta-que-te-pario="sudo route add -net 192.168.0.0/24 gw 192.168.150.126"
alias ff="fastfetch"
alias of="onefetch"
alias tk="tokei"
alias n="nvim"
alias vs="code ."

alias fzb='fzf --preview "bat --theme=gruvbox-dark --color=always --style=numbers --line-range=:500 {}"'
alias fzn='nvim $(fzf --preview "bat --theme=gruvbox-dark --color=always --style=numbers --line-range=:500 {}")'

# tree
alias t='eza -T --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L '
alias ta='eza -aT --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L '
alias lt='eza -lT --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L '
alias lta='eza -alT --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L '
alias llt='eza -lThHimMSuUXZo --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L '
alias llta='eza -alThHimMSuUXZo --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L '

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
  alias bat='batcat --theme=gruvbox-dark'
else
  alias bat='bat --theme=gruvbox-dark'
fi


# **********************************************************************************************************************
source ~/.config/zsh/alias/update.zsh 
source ~/.config/zsh/alias/nushell.zsh 
source ~/.config/zsh/alias/docker.zsh
source ~/.config/zsh/alias/git.zsh
source ~/.config/zsh/alias/copy.zsh
source ~/.config/zsh/alias/pacman.zsh
