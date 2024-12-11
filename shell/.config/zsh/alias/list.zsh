l() {
  nu -c "ls $1 | sort-by name -r"
}

ll() {
  nu -c "ls -l $1 | sort-by name -r"
}

la() {
  nu -c "ls -a $1 | sort-by name -r"
}

lla() {
  nu -c "ls -la $1 | sort-by name -r"
}

# tree
alias t='eza -T --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L '
alias ta='eza -aT --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L '
alias lt='eza -lT --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L '
alias lta='eza -alT --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L '
alias llt='eza -lThHimMSuUXZo --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L '
alias llta='eza -alThHimMSuUXZo --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos -L '
