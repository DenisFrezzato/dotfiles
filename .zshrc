# To install antigen:
# mkdir -p .antigen && curl -L git.io/antigen > .antigen/antigen.zsh
source $HOME/.antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle sudo
antigen bundle docker-compose
antigen bundle colored-man-pages
antigen bundle dotenv
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

antigen theme jreese

antigen apply

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

alias rename="perl-rename"
alias cal="cal -m"

export EDITOR="nvim"

export FZF_DEFAULT_COMMAND='fd --type f'

# Defer initialization of nvm until nvm, node or a node-dependent command is
# run. Ensure this block is only run once if .bashrc gets sourced multiple times
# by checking whether __init_nvm is a function.
# See https://www.growingwiththeweb.com/2018/01/slow-nvm-init.html
if [ -s "$HOME/.nvm/nvm.sh" ] && [ ! "$(whence -w __init_nvm)" = function ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  declare -a __node_commands=('nvm' 'node' 'npm' 'yarn' 'gulp' 'grunt' 'webpack' 'npx' 'nvim')
  function __init_nvm() {
    for i in "${__node_commands[@]}"; do unalias $i; done
    . "$NVM_DIR"/nvm.sh
    unset __node_commands
    unset -f __init_nvm
  }
  for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
fi

[ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"
