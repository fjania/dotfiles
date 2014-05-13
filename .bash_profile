export PATH=/usr/local/bin:/usr/local/sbin:$PATH

alias dir='ls -lsaG'
alias ll='ls -lsaG'
alias vi='vim'

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

shopt -s no_empty_cmd_completion

#export WORKON_HOME=/Users/fjania/dev/venv
#export PROJECT_HOME=/Users/fjania/dev
#source  /usr/local/bin/virtualenvwrapper.sh

function get_branch {
    git branch 2> /dev/null | grep \* | awk '{print "("$2")"}'
}

PS1="\[\033[31m\]\$(get_branch)\[\033[37m\]\n\[\033[00m\]\[\033[38m\]\u@\h:\w$ "


# Do bash completion for manage.py
#. /Users/fjania/dev/venv/findings-django/src/django/extras/django_bash_completion
