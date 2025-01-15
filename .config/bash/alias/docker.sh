alias dlz='lazydocker'

alias dps='nu -c "docker ps | detect columns"'
alias dst='docker stop'

# System
alias dsp='docker system prune'
alias dcp='docker container prune'
alias dvp='docker volume prune'

# Images
alias dimg='nu -c "docker images | detect columns"'
alias drmi='docker rmi'
alias drmia='docker rmi $(docker images -a -q)'

# enter container
dent() {
  docker exec -it "$1" bash
}

dentsh() {
  docker exec -it "$1" sh
}

# Compose
alias dcd='docker compose down'
alias dcu='docker compose up'
alias dcr='docker compose down && docker compose up'
alias dcub='docker compose up --build'
alias dcrb='docker compose down && docker compose up --build'
alias dcud='docker compose up -d'
alias dcrd='docker compose down && docker compose up -d'
alias dcubd='docker compose up -d --build'
alias dcrbd='docker compose down && docker compose up --build -d'
alias dcexe='docker compose exec'
alias dcps='nu -c "docker compose ps | detect columns"'
alias dcat='docker compose attach'

dcent() {
  docker compose exec -it "$1" bash
}

dcentsh() {
  docker compose exec -it "$1" sh
}