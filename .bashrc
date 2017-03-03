# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
stty intr \^n
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespaceG

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else color_prompt=
    fi
fi

source ~/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1


if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[$(tput setaf 5)\]\e[95m$(__git_ps1 " (%s)")\[$(tput setaf 2)\]\n \$\[$(tput sgr0)\] '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    # alias dir='dir --color=auto'
    # alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias h='htop'
# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
# defined my meee
alias setscreen='xset s off'
alias clmk='setxkbmap us -variant colemak'
alias qwrt='setxkbmap us'
alias gc='git commit -a -m'
alias gs='git status'
alias gpff='git pull --ff-only'
alias gpr='git pull --rebase'
alias sshls='ssh -i aws_blog1.pem ubuntu@ec2-54-191-16-100.us-west-2.compute.amazonaws.com'
alias netstat='netstat -tulpn'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

alias szd='cd ~/sumzero/sumzero-data-analytics; source ~/sumzero/sumzero-data-analytics/env_szanal/bin/activate; ./manage.py shell_plus --notebook'
alias sz='cd ~/sumzero/sumzero-data-analytics; workon sz-data-analytics; jupyter notebook'
alias nnet='cd ~/sumzero/sumzero-data-analytics/neural_networks/; source env_neural/bin/activate'

#random bs
alias ihaskell='docker run -it --volume $(pwd):/notebooks --publish 8888:8888 gibiansky/ihaskell:latest'
alias h2o='cd ~/Downloads/h2o-2.8.1.1; java -jar h2o.jar'

#pylearn vars
export PYLEARN2_DATA_PATH=~/sumzero/sumzero-data-analytics/neural_networks/data
export PYLEARN2_VIEWER_COMMAND="eog --new-instance"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
# export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-i386
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=$PATH:$HOME/anaconda/bin # anaconda
PATH=$PATH:$HOME/bin # lein

export PYTHONPATH=/home/cyniphile/caffe/python/:$PYTHONPATH
export PYTHONPATH=/usr/lib/gimp/2.0/python:$PYTHONPATH
### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
# added by Anaconda 1.9.1 installer
export PATH="/home/anaconda/bin:$PATH"

stty -ixon
fortune -s -n 250 | hsterminal

# vi keybindings in shell
set -o vi
bind -m vi-insert "\C-l":clear-screen

alias doom2='chocolate-doom -iwad ~/Documents/Doom2.wad'
alias doom1='chocolate-doom -iwad ~/Documents/Doom1.wad'
alias doomp='chocolate-doom -iwad ~/Documents/Plutonia.wad'
# sumzero
alias cdsz='cd ~/sumzero/webapp/sumzero/'
alias get_all_data='workon awi; python ~/sumzero/analytics-web-interface/get_all_data.py; deactivate;'
alias tmux='TERM=screen-256color-bce tmux new-session -A -s 0'


# docker
alias docker_dev='docker run  -P -v /home/cyniphile/sumzero/analytics-web-interface:/home/analytics-web-interface --name webapp -i cyniphile/analytics-web-interface:latest python run.py; sudo docker ps'
alias drma='docker rm $(comm -13 <(docker ps -a -q --filter="name=data" | sort) <(docker ps -a -q | sort))'
alias dps='docker ps -a'
alias dcu='docker-compose up'
alias di='docker images'
alias drm='docker rm -f'
alias drmi='docker rmi -f'
alias drmia='docker rmi $(sudo docker images | grep "^<none>" | awk "{print $3}")'
alias dcrwbb='docker-compose run web /bin/bash'
alias dcrwbbp='docker-compose run --service-ports web /bin/bash'
# may need to be changed in future
export COMPOSE_API_VERSION=1.21

source `which virtualenvwrapper.sh`

alias find='find . -name $1'

# cyniphile_blog 
function post_cyniphile() {
    cd ~/Dropbox/Projects/cyniphile_blog/_posts/;
    today=$(date +'%Y-%m-%d');
    cp template.markdown $today-$1.markdown
    vim $today-$1.markdown
}

export SPARK_HOME='/home/cyniphile/Downloads/spark-1.3.1/'
export PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH
export PYTHONPATH=$SPARK_HOME/python/lib/py4j-0.8.2.1-src.zip:$PYTHONPATH
# export PYSPARK_SUBMIT_ARGS='--master local[-1]'

export EDITOR='vim'


. /home/cyniphile/torch/install/bin/torch-activate
