alias dlz='lazydocker'

alias dps='docker ps'
alias dst='docker stop'

# System
alias dsp='docker system prune'

# Container
alias dcp='docker container prune'

# Volume
alias dvp='docker volume prune'

# Images
alias dimg='docker images'
alias drmi='docker rmi'
alias drmia='docker rmi $(docker images -a -q)'

# enter container
dent() {
  docker exec -it "$1" bash
}

dentsh() {
  docker exec -it "$1" sh
}

# compose
alias dcd='docker compose down'
# no d
alias dcu='docker compose up'
alias dcr='docker compose down && docker compose up'
alias dcub='docker compose up --build'
alias dcrb='docker compose down && docker compose up --build'
# d
alias dcud='docker compose up -d'
alias dcrd='docker compose down && docker compose up -d'
alias dcubd='docker compose up -d --build'
alias dcrbd='docker compose down && docker compose up --build -d'

alias dcexe='docker compose exec'
alias dcps='docker compose ps'
alias dcat='docker compose attach'

# enter container
dcent() {
  docker compose exec -it "$1" bash
}

dcentsh() {
  docker compose exec -it "$1" sh
}