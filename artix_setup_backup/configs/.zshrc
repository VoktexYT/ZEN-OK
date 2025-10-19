HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# --- COMPLETION ---
autoload -Uz compinit
compinit -d ~/.zsh_compdump

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
setopt COMPLETE_IN_WORD
setopt AUTO_MENU

# --- NAVIGATION ---
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# --- PROMPT ---
setopt PROMPT_SUBST

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'

PROMPT='%F{cyan}%~%f%F{yellow}${vcs_info_msg_0_}%f %F{green}❯%f '

export KEYTIMEOUT=1

alias c='clear'
alias cls='clear'

# --- EXPORTS ---
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=qutebrowser

alias ls="ls --color"
alias v="nvim"

# Path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

