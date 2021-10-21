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


if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export PATH="$HOME/.poetry/bin:$PATH"
. "$HOME/.cargo/env"
