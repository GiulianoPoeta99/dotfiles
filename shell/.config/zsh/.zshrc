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
# zinit light svallory/zsh-shift-select-like-vscode

# OhMyZsh ==============================================================================================================

zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found
zinit snippet OMZP::extract
zinit snippet OMZP::colorize

# Load plugins =========================================================================================================

autoload -U compinit && compinit
zinit cdreplay -q

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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'
zstyle ':fzf-tab:complete:code:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'
zstyle ':fzf-tab:complete:nvim:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'
zstyle ':fzf-tab:complete:cp:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'
zstyle ':fzf-tab:complete:mv:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'
zstyle ':fzf-tab:complete:rm:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'
zstyle ':fzf-tab:complete:cat:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'
zstyle ':fzf-tab:complete:bat:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'
zstyle ':fzf-tab:complete:l:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'
zstyle ':fzf-tab:complete:la:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'
zstyle ':fzf-tab:complete:ll:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'
zstyle ':fzf-tab:complete:lla:*' fzf-preview 'sh ~/.config/zsh/scripts/preview.zsh $realpath'

# Aliases ==============================================================================================================

source ~/.config/zsh/alias/alias.zsh

# Path =================================================================================================================

export PATH="/usr/bin/flutter/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Shell integrations ===================================================================================================

export FUNCNEST=1000 # para modo vi

fpath+=${ZDOTDIR:-~}/.zsh_functions
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$PATH:/home/$USER/.config/nvm/versions/node/v20.11.1/bin/npm"

# pnpm
export PNPM_HOME="/home/gip/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# para usar brave con flutter
export CHROME_EXECUTABLE="brave"

eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval $(thefuck --alias)
eval "$(atuin init zsh)"
# eval "$(zellij setup --generate-auto-start zsh)"

# Keybindings ==========================================================================================================

bindkey -v

# bindkey '^p' history-search-backward
# bindkey '^n' history-search-fordward
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
# bindkey '5~' backward-kill-word

fg_widget() {
    fg
}
zle -N fg_widget
bindkey '^Z' fg_widget

# Prompt ===============================================================================================================

eval "$(starship init zsh)"