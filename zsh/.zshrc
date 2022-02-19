#### FIG ENV VARIABLES ####
# Please make sure this block is at the start of this file.
[ -s ~/.fig/shell/pre.sh ] && source ~/.fig/shell/pre.sh
#### END FIG ENV VARIABLES ####

# Activate Ruby environment manager.
eval "$(rbenv init -)"

# Activate Node version manager.
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Path to your oh-my-zsh installation.
export ZSH="/Users/derek.nordgren/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="pygmalion"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

plugins=(
  aws
  docker
  docker-compose
  droplr
  git
  git-prompt
  node
  yarn
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='bbedit'
fi

source ~/.iterm2_shell_integration.zsh
export PATH=$HOME/bin:$PATH

# https://samuelsson.dev/sign-git-commits-on-github-with-gpg-in-macos/
# https://gist.github.com/paolocarrasco/18ca8fe6e63490ae1be23e84a7039374
export GPG_TTY=$(tty)

# Add pi_rsa so Emacs Tramp works with public key authentication.
ssh-add ~/.ssh/pi_rsa.pem

alias ls="ls -lha"
alias tf="terraform"
alias g="git"
alias txtedit="open -a TextEdit" # followed by filename
alias obs="cd ~/vaults/working-notes"
alias bb="bbedit"
alias zshconfig="bbedit ~/.zshrc"
alias td="todoist"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

export PATH="$HOME/.rbenv/bin:$PATH"

export PATH="/usr/local/opt/mongodb-community@3.6/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export LESS="-Xr"
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/derek/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/derek/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/derek/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/derek/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#### FIG ENV VARIABLES ####
# Please make sure this block is at the end of this file.
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####
