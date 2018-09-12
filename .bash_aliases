alias h='htop'
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
# defined my meee
alias gc='git commit -a -m'
alias gs='git status'
alias gpff='git pull --ff-only'
alias gprs='git stash; git pull --rebase; git stash pop'
alias gpr='git pull --rebase origin master;'
alias netstat='netstat -tulpn'
alias vi='nvim'
alias r='quick_grep'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias doom2='chocolate-doom -iwad ~/Documents/Doom2.wad'
alias doom1='chocolate-doom -iwad ~/Documents/Doom1.wad'
alias doomp='chocolate-doom -iwad ~/Documents/Plutonia.wad'
alias tmux='TERM=screen-256color-bce tmux new-session -A -s 0'



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

#random bs
alias ihaskell='docker run -it --volume $(pwd):/notebooks --publish 8888:8888 gibiansky/ihaskell:latest'

# custora
alias cspark='cd ~/custora && opt/spark/bin/spark-shell --jars spark/apps/target/scala-2.11/custora-spark-apps.jar'
