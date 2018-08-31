export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if [ -f ~/.bashrc  ]; then
    source ~/.bashrc
fi

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

eval "$(rbenv init -)"
