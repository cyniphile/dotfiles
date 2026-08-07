
[[ -e ~/.shellrc ]] && emulate sh -c 'source ~/.shellrc'
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}



# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# oh-my-zsh — dropped 2026-07-09 for faster tabs (~80ms/tab): no plugins were
# enabled and the prompt comes from powerlevel10k, so OMZ only supplied the
# lib defaults now inlined below. It also used to stomp the `ls` alias from
# .bash_aliases (lsd) with `ls -G`; dropping it restores lsd. To revert:
# uncomment these two lines and delete down to "end oh-my-zsh replacement".
# export ZSH="/Users/luke/.oh-my-zsh"
# source $ZSH/oh-my-zsh.sh

# --- oh-my-zsh replacement --------------------------------------------------

bindkey -e  # explicit emacs keymap (EDITOR=nvim would otherwise pick vi mode)
unsetopt flow_control  # don't let the tty eat ^Q/^S — the ^q smart_open binding needs it

# arrows search history by typed prefix; sane Home/End/Delete/word-jumps
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search    # application cursor mode —
bindkey '^[OB' down-line-or-beginning-search  # some TUIs leave it enabled
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[3;5~' kill-word
bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[Z' reverse-menu-complete
bindkey ' ' magic-space  # expand !!-style history refs when space is typed

# edit the current command line in $EDITOR with ctrl-x ctrl-e
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# auto-quote ?/&/; while typing a URL, or pasting one (quoted only if the
# whole paste is a URL). bracketed-paste-url-magic inserts pastes in one shot;
# the old bracketed-paste-magic fed every pasted char through zle widgets,
# which took ~350ms for a 5KB paste and ~2.5s for 20KB.
autoload -Uz bracketed-paste-url-magic url-quote-magic
zle -N bracketed-paste bracketed-paste-url-magic
zle -N self-insert url-quote-magic

# history sizes and cross-tab sharing OMZ used to set
HISTSIZE=50000
SAVEHIST=10000
setopt SHARE_HISTORY HIST_VERIFY

setopt auto_cd auto_pushd pushd_ignore_dups interactive_comments long_list_jobs
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.venv,venv}'
alias diff='diff --color'
export LESS="${LESS:--R}"
export PAGER="${PAGER:-less}"

# completion behavior: menu selection, case-insensitive + partial matching
zmodload -i zsh/complist
setopt complete_in_word always_to_end
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors 'di=1;36' 'ln=35' 'so=32' 'pi=33' 'ex=31' 'bd=34;46' 'cd=34;43' 'su=30;41' 'sg=30;46' 'tw=30;42' 'ow=30;43'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
[[ -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" ]] || mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

# compinit: trust today's dump (-C skips the audit + freshness scan, ~40ms);
# full audited rebuild at most once a day, byte-compiled in the background
autoload -Uz compinit
() {
  setopt local_options extended_glob
  local dump=$HOME/.zcompdump
  if [[ -n $dump(#qN.mh-24) ]]; then
    compinit -C -d $dump
  else
    compinit -d $dump
    touch $dump
    { zcompile $dump } &!
  fi
}

# terminal tab title: cwd at the prompt, the running command during one
autoload -Uz add-zsh-hook
_title_precmd()  { print -Pn '\e]0;%15<..<%~%<<\a' }
_title_preexec() { local c=${1//$'\n'/ }; print -rn $'\e]0;'"${c[1,100]}"$'\a' }
add-zsh-hook precmd _title_precmd
add-zsh-hook preexec _title_preexec

# --- end oh-my-zsh replacement ----------------------------------------------

export PATH="/Users/luke/.cargo/bin:$PATH"


fpath+=~/.zfunc

autoload -Uz bashcompinit; bashcompinit

# fzf shortcut (cool!)
bindkey -s '^p' 'smart_cd $(fzf_capped)^M'
bindkey -s '^q' 'smart_open $(fzf_capped)^M'
#


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"


setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS



# Created by `userpath` on 2020-06-16 20:55:54
export PATH="$PATH:/Users/luke/.local/bin"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# pyenv — migrated to mise on 2026-06-29. Kept commented for rollback;
# to revert: uncomment this block and remove the mise block below.
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# fi

# mise — runtime & version manager (replaces pyenv). Shims instead of
# `eval "$(mise activate zsh)"`: activation spawned mise twice per tab
# (~140ms) and its output can't be cached (it bakes the current PATH into
# an `export PATH=...` line). Shims cost nothing at startup and still pick
# the right python per directory — resolved at exec time, like pyenv shims.
# Trade-off: [env] vars in mise.toml files no longer auto-load (none used).
[ -d "$HOME/.local/share/mise/shims" ] && export PATH="$HOME/.local/share/mise/shims:$PATH"


# Theme comes from `brew install powerlevel10k` (see setup.sh), not a manual clone.
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

export EDITOR='nvim'


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/luke/Library/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/luke/Library/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/luke/Library/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/luke/Library/google-cloud-sdk/completion.zsh.inc'; fi


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/luke/.opam/opam-init/init.zsh' ]] || source '/Users/luke/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration
# export DYLD_FALLBACK_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_FALLBACK_LIBRARY_PATH"

# Ctrl+V (0x16) pastes clipboard text at the prompt.
# Paired with iTerm's Cmd+V -> Invoke Script Function smart_paste(...) binding
# (~/Library/Application Support/iTerm2/Scripts/AutoLaunch/smart_paste.py):
# text is sent as a bracketed paste; when the clipboard holds an image the
# script sends 0x16 instead, which Claude Code turns into an image paste and
# this widget turns into the clipboard's text form (if any) at a plain prompt.
# Harmless in VS Code (Cmd+V there is handled by VS Code and never sends 0x16
# to zsh). Replaces zsh's quoted-insert.
paste-clipboard() { LBUFFER+="$(pbpaste)" }
zle -N paste-clipboard
bindkey '^V' paste-clipboard

# nvm — lazy-loaded; eagerly sourcing nvm.sh cost ~0.5s warm / ~1s cold per tab.
# The default node version goes straight onto PATH here; the real nvm is only
# sourced on the first `nvm` invocation (--no-use skips its auto-activation,
# which is redundant since PATH is already set).
export NVM_DIR="$HOME/.nvm"
() {
  local default
  default="$(cat "$NVM_DIR/alias/default" 2>/dev/null)"
  local -a dirs=("$NVM_DIR"/versions/node/v${default#v}*(Nn))
  (( ${#dirs} )) && path=("${dirs[-1]}/bin" $path)
}
nvm() {
  unfunction nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

# Jira API token lives in the macOS Keychain (item: jira-api-token) — safe to
# commit; the secret never appears in dotfiles. Fetched asynchronously (the
# keychain call cost ~20-50ms of tab startup): the background process starts
# now and zle delivers the result as soon as the line editor is up, so the
# token is exported milliseconds after the first prompt appears.
() {
  local fd
  exec {fd}< <(security find-generic-password -s jira-api-token -w 2>/dev/null)
  _jira_token_ready() {
    local fd=$1 tok
    IFS= read -r tok <&$fd
    [[ -n $tok ]] && export JIRA_API_TOKEN=$tok
    zle -F $fd
    exec {fd}<&-
    unfunction _jira_token_ready
  }
  zle -F $fd _jira_token_ready
}
