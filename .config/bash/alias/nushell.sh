alias nsh="nu -c"

ps() {
  nu -c "ps $@"
}

df() {
  nu -c "df $1 | detect columns $2"
}

l() {
  nu -c "ls $1 | sort-by name"
}

ll() {
  nu -c "ls -l $1 | sort-by name"
}

la() {
  nu -c "ls -a $1 | sort-by name"
}

lla() {
  nu -c "ls -la $1 | sort-by name"
}

open() {
  nu -c "open $1 $2"
}

see() {
  nu -c "open $1 | table --expand"
}