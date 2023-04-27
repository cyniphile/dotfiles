# some more ls aliases
alias ll='lsd -alF'
alias ls='lsd'
alias la='lsd -A'
alias l='ls -CF'
alias tree='ls --tree'

# git
alias gc='git commit -m'
alias gk='git checkout'
alias gca='git commit -a -m'
alias gs='gitui'
alias e='exit'
alias gl='git log'
alias ga='git add'
alias gd='git diff'
alias gpr='git pull --rebase origin main;'
alias gprs='git stash; gpr; git stash pop'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gu='gitui'

# random
alias netstat='netstat -tulpn'
alias vi='nvim'
alias ,a='quick_grep'
alias tmux='TERM=screen-256color-bce tmux new-session -A -s 0'
alias h='htop'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# docker
alias drma='docker rm $(comm -13 <(docker ps -a -q --filter="name=data" | sort) <(docker ps -a -q | sort))'
alias dps='docker ps -a'
alias dcu='docker-compose up'
alias di='docker images'
alias drm='docker rm -f'
alias drmi='docker rmi -f'
alias drmia='docker rmi $(sudo docker images | grep "^<none>" | awk "{print $3}")'
alias dcrwbbw='docker-compose run -p 127.0.0.1:9999:9999 web /bin/bash'
alias dcrwbb='docker-compose run web /bin/bash'
alias dcrwbbp='docker-compose run --service-ports web /bin/bash'


