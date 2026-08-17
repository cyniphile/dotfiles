#!/usr/bin/env bash
# PreToolUse/Bash hook: refuse `git worktree add` targeting a direct child of ~/dev.
#
# Agents shelling out to `git worktree add /Users/luke/dev/<slug>` bypass the
# managed worktree directory and clutter the top level of ~/dev, making repos
# indistinguishable from worktrees. Deny those and name the correct path.
#
# Change BUCKET to ".worktrees" if you'd rather these live outside the directory
# Claude Code sweeps (then add ".worktrees/" to ~/.gitignore).
BUCKET=".claude/worktrees"

payload=$(cat)
cmd=$(jq -r '.tool_input.command // empty' <<<"$payload")
case "$cmd" in *"worktree add"*) ;; *) exit 0;; esac

cwd=$(jq -r '.cwd // empty' <<<"$payload"); [[ -z $cwd ]] && cwd="$PWD"

rest="${cmd#*worktree add}"; rest="${rest%%[;|&]*}"   # this git invocation only
read -r -a toks <<<"$rest"; path=""; i=0
while (( i < ${#toks[@]} )); do
  case "${toks[i]}" in
    -b|-B|--reason) (( i += 2 ));;   # these consume a following argument
    -*)             (( i += 1 ));;
    *)              path="${toks[i]}"; break;;
  esac
done
[[ -z $path ]] && exit 0

[[ $path == /* ]] && abs="$path" || abs="$cwd/$path"

norm=""; IFS=/ read -r -a segs <<<"$abs"              # resolve . and .. in-shell
for seg in "${segs[@]}"; do
  case "$seg" in ""|.) ;; ..) norm="${norm%/*}";; *) norm="$norm/$seg";; esac
done

if [[ "${norm%/*}" == "$HOME/dev" ]]; then
  jq -n --arg p "$norm" --arg b "$BUCKET" '{hookSpecificOutput:{
    hookEventName:"PreToolUse", permissionDecision:"deny",
    permissionDecisionReason:("Refusing to create a worktree at \($p) — direct children of ~/dev are reserved for repos. Put it inside the repo instead: git worktree add \($b)/<name> <ref>")}}'
fi
exit 0
