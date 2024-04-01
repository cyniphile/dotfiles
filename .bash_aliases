alias h='htop'
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias tree='ls --tree'

# git
alias gc='git commit -m'
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

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias doom2='chocolate-doom -iwad ~/Documents/Doom2.wad'
alias doom1='chocolate-doom -iwad ~/Documents/Doom1.wad'
alias doomp='chocolate-doom -iwad ~/Documents/Plutonia.wad'
# sumzero
alias tmux='TERM=screen-256color-bce tmux new-session -A -s 0'
alias sz='cd ~/sumzero/sumzero-data-analytics; workon sz-data-analytics; jupyter lab'



# docker
alias docker_dev='docker run  -P -v /home/cyniphile/sumzero/analytics-web-interface:/home/analytics-web-interface --name webapp -i cyniphile/analytics-web-interface:latest python run.py; sudo docker ps'
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

#random bs
alias ihaskell='docker run -it --volume $(pwd):/notebooks --publish 8888:8888 gibiansky/ihaskell:latest'
