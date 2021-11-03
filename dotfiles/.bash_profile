export BASH_SILENCE_DEPRECATION_WARNING=1
alias s="git status"

. /usr/local/etc/bash_completion.d/git-completion.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
