# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[$(tput setaf 5)\]$(__git_ps1 " (%s)")\[$(tput setaf 2)\]] \n \$\[$(tput sgr0)\] '
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
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
#defined my meee
alias setscreen='xset s off'
alias clmk='setxkbmap us -variant colemak'
alias qwrt='setxkbmap us'
alias gc='git commit -a -m'
alias gs='git status'
alias pff='git pull --ff-only'
alias sshls='ssh -i aws_blog1.pem ubuntu@ec2-54-191-16-100.us-west-2.compute.amazonaws.com'

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
alias sz='cd ~/sumzero/sumzero-data-analytics; source ~/sumzero/sumzero-data-analytics/env_szanal/bin/activate; ipython notebook --profile dark'
alias h2o='cd ~/Downloads/h2o-2.8.1.1; java -jar h2o.jar'
alias nnet='cd ~/sumzero/sumzero-data-analytics/neural_networks/; source env_neural/bin/activate'
alias tmux='tmux -2'

#pylearn vars
export PYLEARN2_DATA_PATH=~/sumzero/sumzero-data-analytics/neural_networks/data
export PYLEARN2_VIEWER_COMMAND="eog --new-instance"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-i386

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=$PATH:$HOME/anaconda/bin # anaconda

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
# added by Anaconda 1.9.1 installer
export PATH="/home/anaconda/bin:$PATH"

fortune -s -n 250 | hsterminal

#vi keybindings in shell
set -o vi
bind -m vi-insert "\C-l":clear-screen

#sumzero
alias latest_ideas='cd ~/sumzero/sumzero-data-analytics/dataframes/; today=$(date +'%m-%d-%Y'); curl -o "szapidata_$today.json" -u access:2Ej8Ggb1Utmr https://sumzero.com/api/analysis/ideas'

#docker
alias docker_dev='sudo docker run  -P -v /home/cyniphile/sumzero/analytics-web-interface:/home/analytics-web-interface --name webapp -i cyniphile/analytics-web-interface:latest python run.py; sudo docker ps'
alias dps='sudo docker ps -a'
alias di='sudo docker images'
alias drm='sudo docker rm -f'
alias drmi='sudo docker rmi -f'
alias drma='sudo docker rm -f $(sudo docker ps -a -q)'
alias drmia='sudo docker rmi $(sudo docker images | grep "^<none>" | awk "{print $3}")'
export DOCKER_HOST=tcp://localhost:4243


#cyniphile_blog 
function post_cyniphile() {
    cd ~/Dropbox/Projects/cyniphile_blog/_posts/;
    today=$(date +'%Y-%m-%d');
    cp template.markdown $today-$1.markdown
    vim $today-$1.markdown
}

source ~/.autoenv/activate.sh
