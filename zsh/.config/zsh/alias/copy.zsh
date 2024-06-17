# comando para copiar path
function copypath {
  # If no argument passed, use current directory
  local file="${1:-.}"

  # If argument is not an absolute path, prepend $PWD
  [[ $file = /* ]] || file="$PWD/$file"

  # Copy the absolute path without resolving symlinks
  # If clipcopy fails, exit the function with an error
  print -n "${file:a}" | xclip -selection clipboard || return 1

  echo ${(%):-"%B${file:a}%b copied to clipboard."}
}

# comando para copiar contenido de archivo
function copyfile {
  emulate -L zsh
  echo $1 | xclip -selection clipboard
}

# comando para copiar buffer
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