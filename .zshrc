# to install antigen:
# mkdir -p .antigen && curl -L git.io/antigen > .antigen/antigen.zsh
source $HOME/.antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle sudo
antigen bundle archlinux
antigen bundle docker-compose
antigen bundle colored-man-pages
antigen bundle common-aliases
antigen bundle dotenv
antigen bundle node
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions

antigen theme agnoster

antigen apply

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

alias rename="perl-rename"
alias cal="cal -m"

export EDITOR="vim"

export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

