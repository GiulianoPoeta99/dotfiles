# Plugin manager =======================================================================================================

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME"/zinit.zsh

# Plugins ==============================================================================================================

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light svallory/zsh-shift-select-like-vscode

# OhMyZsh ==============================================================================================================

zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::extract
zinit snippet OMZP::colorize

# Load plugins =========================================================================================================

autoload -U compinit && compinit
zinit cdreplay -q

# Keybindings ==========================================================================================================

bindkey -e

bindkey '^p' history-search-backward
bindkey '^n' history-search-fordward

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

bindkey '5~' backward-kill-word

# History ==============================================================================================================

HISTSIZE=5000
HISTFILE="$XDG_STATE_HOME"/zsh/history
SAVEHIST=5000
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling ===================================================================================================

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -al --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -al --group-directories-first --icons=auto --color=always --color-scale --hyperlink --git --git-repos $realpath'
zstyle ':fzf-tab:complete:code:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'
zstyle ':fzf-tab:complete:nvim:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'
zstyle ':fzf-tab:complete:cp:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'
zstyle ':fzf-tab:complete:mv:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'
zstyle ':fzf-tab:complete:rm:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'

# Aliases ==============================================================================================================

source ~/.config/zsh/alias/alias.zsh

alias c='clear'
alias docker-la-puta-que-te-pario="sudo route add -net 192.168.0.0/24 gw 192.168.150.126"

# Path ==============================================================================================================

export PATH="/usr/bin/flutter/bin:$PATH"

# Shell integrations ===================================================================================================

fpath+=${ZDOTDIR:-~}/.zsh_functions
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$PATH:/home/$USER/.config/nvm/versions/node/v20.11.1/bin/npm"

# para usar brave con flutter
export CHROME_EXECUTABLE="brave"

eval "$(fzf --zsh)"

eval "$(zoxide init --cmd cd zsh)"

# eval "$(zellij setup --generate-auto-start zsh)"

eval $(thefuck --alias)

# Prompt ===============================================================================================================

eval "$(starship init zsh)"
