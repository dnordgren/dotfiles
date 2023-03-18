# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
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
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

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

function halp {
  echo "infra_role_assume acct role session_name"
  echo "infra_role_unset"
  echo "kube_ctx_unset"
  echo "kube_ctx_set_prod_eks"
  echo "ssm instance_id"
  echo "whats_running_any_tcp_port"
  echo "whats_running_this_tcp_port port"
  echo "route53_query_all_zones"
  echo "rrg query"
  echo "gtt tag_name"
  echo "ip_pls"
  echo "fuz"
}

infra_role_assume () {
  readonly acct=${1:?"The account ID must be specified."}
  readonly role=${2:?"The role ID must be specified."}
  readonly session_name=${3:?"The session name must be specified."}

  OUT=$(aws sts assume-role --role-arn arn:aws:iam::$acct\:role/$role --role-session-name $session_name);
  export AWS_ACCESS_KEY_ID=$(echo $OUT | jq -r '.Credentials''.AccessKeyId');
  export AWS_SECRET_ACCESS_KEY=$(echo $OUT | jq -r '.Credentials''.SecretAccessKey');
  export AWS_SESSION_TOKEN=$(echo $OUT | jq -r '.Credentials''.SessionToken');

  echo "Assumed $role in $acct. Use infra_role_unset to exit."
}

function infra_role_unset {
  unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
}

function kube_ctx_unset {
  kubectl config unset current-context
}

function kube_ctx_set_prod_eks {
  aws eks --region us-east-1 update-kubeconfig --name p-eks-3c86d
}

ssm () {
  readonly instance_id=${1:?"The instance_id must be specified."}
  aws ssm start-session --target $instance_id
}

function ip_pls {
  my_ip=$(curl -s ipinfo.io/ip)
  echo $my_ip
  echo $my_ip | pbcopy
  echo "IP copied to clipboard"
}

function whats_running_any_tcp_port {
  echo "Running $ lsof -nP -iTCP -sTCP:LISTEN"
  lsof -nP -iTCP -sTCP:LISTEN
}

whats_running_this_tcp_port () {
  readonly port=${1:?"The port must be specified."}
  echo "Running $ lsof -nP -iTCP:$port -sTCP:LISTEN"
  lsof -nP -iTCP:"$port" -sTCP:LISTEN
}

function route53_query_all_zones {
  aws route53 list-hosted-zones | jq '.[] | .[] | .Id' | sed 's!/hostedzone/!!' | sed 's/"//g'> zones
  mv ~/Documents/hudl/route53-records.json ~/Documents/hudl/route53-records.json.bak
  for z in `cat zones`; do
    echo $z;
    aws route53 list-resource-record-sets --hosted-zone-id $z >> ~/Documents/hudl/route53-records.json;
  done
  rm zones
  Echo "~/Documents/hudl/route53-records.json has been updated"
}

rrg () {
  readonly query=${1:?"Query must be specified."}
  rg $query ~/Documents/hudl/route53-records.json -A 5 -B 5
}

function gtt {
  readonly tag_name=${1:?"The new tag name must be specified."}
  export MY_NEW_TAG="$tag_name"
  echo "executing git tag -a $MY_NEW_TAG -m '$MY_NEW_TAG'"
  git tag -a $MY_NEW_TAG -m "$MY_NEW_TAG"
  echo "run gttp to push the tag to origin"
}
alias gttp="git push origin $MY_NEW_TAG"

function fuz {
  fzf --print0 | xargs -0 -o bbedit
}

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
# https://gist.github.com/oseme-techguy/bae2e309c084d93b75a9b25f49718f85
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
alias doom="emacs -nw"
alias dl="cd ~/Downloads"
alias docs="cd ~/Documents/hudl"
alias repos="cd ~/repos/hudl"
alias vault="cd ~/vaults/working-notes"

fpath+=~/.zfunc

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

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
