# Load the environment variables - this in not kept in scm, assuming
# it's particular to the machine/dev env we're using.
if [ -f .env ]; then
    source .env
fi

alias dir='ls -lsaG'
alias ll='ls -lsaG'
alias vi='vim'

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi
shopt -s no_empty_cmd_completion

if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
fi

function get_branch {
    git branch 2> /dev/null | grep \* | awk '{print "("$2")"}'
}
PS1="\[\033[31m\]\$(get_branch)\[\033[37m\]\n\[\033[00m\]\[\033[38m\]\u@\h:\w$ "

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

### Don't show dupes in the history
export HISTCONTROL=ignoredups
