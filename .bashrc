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


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk-i386
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

#export PATH="~/.local/bin:$PATH"

stty -ixon
fortune -s -n 250 | hsterminal

# vi keybindings in shell
set -o vi
set keymap vi-command                                                                            
bind -m vi-command "v":""
bind -m vi-insert "\C-l":clear-screen

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# ctrl-p: open fuzzy finder, search for files, use default program to open 
# and cd to dir of file
function smart_open() {
    if [ "$1" = "" ]
    then
        return 1
    fi
    file_kind=$(xdg-mime query filetype $1 | xargs xdg-mime query default)
    if [ "$file_kind" = "sublime_text.desktop" ] || [ "$file_kind" = "" ] || [ "$file_kind" = "atom.desktop" ] || [ "$file_kind" = "gvim.desktop" ]
    then
        vi $1
    else
        xdg-open $1
    fi
    dir=$(dirname "$1") && cd "$dir"
}

# fzf shortcut (cool!)
bind -x '"\C-p": cd && smart_open $(fzf-tmux)'
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}

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


export PATH="$HOME/neovim/bin:$PATH"
export EDITOR='nvim'

. ~/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
. /home/cyniphile/torch/install/bin/torch-activate

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
