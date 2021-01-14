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
alias xclip="xclip -sel clipboard"

export ANDROID_HOME="$HOME/Android/Sdk"
# Output of `stack path --compiler-tools-bin`, hardcoded for performance.
STACK_COMPILER_TOOLS="$HOME/.stack/compiler-tools/x86_64-linux-tinfo6/ghc-8.8.4/bin"
export PATH="$ANDROID_HOME/tools:/opt/jcryptool:$HOME/.local/bin:$STACK_COMPILER_TOOLS:$PATH"
export EDITOR="nvim"

export FZF_DEFAULT_COMMAND='fd --type f'
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

[ -f "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env" ] && source "${GHCUP_INSTALL_BASE_PREFIX:=$HOME}/.ghcup/env"

# fnm
export PATH="$HOME/.fnm:$PATH"
eval "`fnm env --use-on-cd`"
