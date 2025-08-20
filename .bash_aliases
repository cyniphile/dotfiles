# some more ls aliases
alias ic='imgcat -W 100%'
alias rgh='rg --hidden'
alias rg='rg -l'
alias ls='lsd'
alias ll='ls -l   --truncate-owner-after 0 --total-size -A'
alias la='lsd -A'
alias lla='ll -A'
alias tree='ls --tree'
alias yd='cd ~/Downloads && y'
alias gd='cd ~/Downloads && y'
alias p='ipython'
# git
alias gk='git checkout'
# auto create new branches with a username, based of either "main" or "master
gkb() {
    git fetch
    if git show-ref --verify --quiet refs/remotes/origin/main; then
        base_branch="main"
    elif git show-ref --verify --quiet refs/remotes/origin/master; then
        base_branch="master"
    else
        echo "Neither main nor master branch found."
        return 1
    fi
    git checkout -b "$USER/$1" -t origin/$base_branch
}
alias gs='gitui'
alias gpr='git pull --rebase origin main;'
alias ghpr='gh pr create'
alias gprs='git stash; gpr; git stash pop'
alias gp='git push'
alias gpf='git push --force-with-lease'

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


