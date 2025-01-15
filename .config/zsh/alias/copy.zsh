# comando para copiar path
function copypath {
  local file="${1:-.}"

  [[ $file = /* ]] || file="$PWD/$file"

  print -n "${file:a}" | xclip -selection clipboard || return 1

  echo ${(%):-"%B${file:a}%b copied to clipboard."}
}

function copyfile {
  emulate -L zsh
  echo $1 | xclip -selection clipboard
}

copybuffer () {
  if command -v xclip &>/dev/null; then
    printf "%s" "$BUFFER" | xclip -selection clipboard
  else
    zle -M "xclip not found. Please make sure you have it installed."
  fi
}

zle -N copybuffer

bindkey -M emacs "^O" copybuffer
bindkey -M viins "^O" copybuffer
bindkey -M vicmd "^O" copybuffer