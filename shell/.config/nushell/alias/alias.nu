def c [] {
   clear
}
def rmrf [] {
   rm -rf
}
def ff [] {
   fastfetch
}
def of [] {
   onefetch
}
def tk [] {
   tokei
}
def n [] {
   nvim
}
def vs [] {
   code .
}

def fzb [] {
   fzf --preview "bat --theme=gruvbox-dark --color=always --style=numbers --line-range=:500 {}"
}
def fzn [] {
   nvim (fzf --preview "bat --theme=gruvbox-dark --color=always --style=numbers --line-range=:500 {}")
}

def l [path?: string] {
   if ($path | is-not-empty) {
      ls $path | sort-by name
   } else {
      ls | sort-by name
   }
}

def ll [path?: string] {
   if ($path | is-not-empty) {
      ls -l $path | sort-by name
   } else {
      ls -l | sort-by name
   }
}

def la [path?: string] {
   if ($path | is-not-empty) {
      ls -a $path | sort-by name
   } else {
      ls -a | sort-by name
   }
}

def lla [path?: string] {
   if ($path | is-not-empty) {
      ls -la $path | sort-by name
   } else {
      ls -la | sort-by name
   }
}

def see [path: string] {
  open $path | table --expand
}

def t [] {
   eza -T --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L
}
def ta [] {
   eza -aT --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L
}
def lt [] {
   eza -lT --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L
}
def lta [] {
   eza -alT --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L
}
def llt [] {
   eza -lThHimMSuUXZo --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L
}
def llta [] {
   eza -alThHimMSuUXZo --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L
}

def pls [...args] {
  if (which sudo) {
    sudo $args
  } else if (which doas) {
    doas $args
  } else {
    echo "Error: Ni sudo ni doas están instalados en el sistema."
  }
}

if (which batcat | is-not-empty) {
   def bat [] {
      batcat --theme=gruvbox-dark
   }
} else {
   # alias bat = bat --theme=gruvbox-dark # esto no funciona en nu
}

source ~/.config/nushell/alias/update.nu
source ~/.config/nushell/alias/docker.nu
source ~/.config/nushell/alias/git.nu
source ~/.config/nushell/alias/copy.nu
source ~/.config/nushell/alias/pacman.nu
