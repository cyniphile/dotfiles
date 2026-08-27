#!/bin/bash
set -e

DOTFILES="$HOME/dotfiles"

echo "=== macOS Dotfiles Setup ==="

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "This script is for macOS only"
    exit 1
fi

# Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Core brew packages
echo "Installing brew packages..."
brew install git neovim zsh mise
brew install ripgrep fd fzf yazi gitui lsd
brew install jq                 # the Claude Code worktree hook parses its payload with jq
brew install fortune

# Powerlevel10k. --HEAD because upstream stopped tagging releases after v1.20.0
# (Feb 2024) while master stayed maintained; the stable bottle is stuck on an
# older build. Update with: brew upgrade --fetch-HEAD powerlevel10k
brew install --HEAD powerlevel10k

# GUI apps
echo "Installing apps..."
brew install --cask rectangle

# Fonts
echo "Installing fonts..."
brew tap homebrew/cask-fonts 2>/dev/null || true
brew install --cask font-hack-nerd-font

# vim-plug for neovim
if [[ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" ]]; then
    echo "Installing vim-plug..."
    curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Create necessary directories
echo "Creating directories..."
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/yazi"
mkdir -p "$HOME/.config/git"
mkdir -p "$HOME/.claude"
mkdir -p "$HOME/Library/Application Support/Code/User"

# Symlinks
echo "Creating symlinks..."

link() {
    local src="$1"
    local dest="$2"
    if [[ -L "$dest" ]]; then
        rm "$dest"
    elif [[ -e "$dest" ]]; then
        echo "  Backing up existing $dest"
        mv "$dest" "$dest.backup"
    fi
    ln -s "$src" "$dest"
    echo "  $dest -> $src"
}

# Shell configs
link "$DOTFILES/.zshrc" "$HOME/.zshrc"
link "$DOTFILES/.bashrc" "$HOME/.bashrc"
link "$DOTFILES/.bash_profile" "$HOME/.bash_profile"
link "$DOTFILES/.bash_aliases" "$HOME/.bash_aliases"
link "$DOTFILES/.shellrc" "$HOME/.shellrc"
link "$DOTFILES/.p10k.zsh" "$HOME/.p10k.zsh"

# Git
link "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
link "$DOTFILES/.gitignore" "$HOME/.gitignore"
link "$DOTFILES/key_config.ron" "$HOME/.config/git/key_bindings.ron"

# Vim/Neovim
link "$DOTFILES/.vimrc" "$HOME/.config/nvim/init.vim"
link "$DOTFILES/nvim/after" "$HOME/.config/nvim/after"

# Claude Code. settings.json is deliberately absent — see the hook step below.
link "$DOTFILES/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
link "$DOTFILES/claude/keybindings.json" "$HOME/.claude/keybindings.json"
link "$DOTFILES/claude/hooks" "$HOME/.claude/hooks"

# VS Code
link "$DOTFILES/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
link "$DOTFILES/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
link "$DOTFILES/tasks.json" "$HOME/Library/Application Support/Code/User/tasks.json"

# Tools
link "$DOTFILES/.fdignore" "$HOME/.fdignore"

# iTerm2 AutoLaunch scripts:
#   smart_paste  - Cmd+V: bracketed-paste text, Ctrl+V for images
#   snap_window  - Cmd+Opt+Left/Right/Up: hotkey window to half screen or full
#   keymaps      - writes the Cmd chords in iterm2/keymaps.json into the Hotkey
#                  profile, as CSI-u escape sequences that nvim reads as
#                  <D-...> keys and the shell binds raw (Cmd+Shift+P). Runs at
#                  every launch, so the profile follows the file.
# The Invoke Script Function bindings themselves live in the iTerm2 state
# export loaded in step 3 below.
mkdir -p "$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch"
link "$DOTFILES/iterm2/smart_paste.py" "$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch/smart_paste.py"
link "$DOTFILES/iterm2/snap_window.py" "$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch/snap_window.py"
link "$DOTFILES/iterm2/keymaps.py" "$HOME/Library/Application Support/iTerm2/Scripts/AutoLaunch/keymaps.py"

# Yazi - link all files
for f in "$DOTFILES/yazi/"*; do
    fname=$(basename "$f")
    link "$f" "$HOME/.config/yazi/$fname"
done

# Rectangle. Deliberately a copy, not a link: Rectangle reads
# ~/Library/Application Support/Rectangle/RectangleConfig.json once at launch
# and then renames it with a timestamp so it isn't reapplied, and it refuses
# outright to load a config that is a symlink or world-writable. So the file has
# to be a private copy Rectangle is free to consume. Re-run setup.sh after
# editing RectangleConfig.json.
echo "Applying Rectangle config..."
RECTANGLE_SUPPORT="$HOME/Library/Application Support/Rectangle"
mkdir -p "$RECTANGLE_SUPPORT"
install -m 600 "$DOTFILES/RectangleConfig.json" "$RECTANGLE_SUPPORT/RectangleConfig.json"
if pgrep -x Rectangle >/dev/null; then
    killall Rectangle
    sleep 1
fi
open -a Rectangle
# The launch that imports the config writes the new prefs but keeps the hotkeys
# it registered at startup, so nothing is bound until Rectangle is launched
# again. Wait for the import (the file disappearing under its own rename) and
# then restart.
for _ in $(seq 30); do
    [[ -f "$RECTANGLE_SUPPORT/RectangleConfig.json" ]] || break
    sleep 1
done
if [[ -f "$RECTANGLE_SUPPORT/RectangleConfig.json" ]]; then
    echo "  Rectangle hasn't imported it yet — approve its prompt, then restart Rectangle"
else
    killall Rectangle 2>/dev/null || true
    sleep 1
    open -a Rectangle
    echo "  Imported and reloaded"
fi

# fzf keybindings
echo "Setting up fzf..."
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# Install terminal-notifier for the Claude Code Stop/Notification hooks
brew install terminal-notifier 2>/dev/null || true

# Claude Code: register the worktree hook.
#
# ~/.claude/settings.json is NOT tracked or symlinked. Claude Code writes an
# autoMode block into it that names private repos, internal domains and
# buckets, and this repo is public. So merge the one entry that depends on a
# tracked file instead of shipping the whole file. Idempotent: re-running
# replaces the entry rather than appending a duplicate.
echo "Registering the Claude Code worktree hook..."
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
if [[ ! -f "$CLAUDE_SETTINGS" ]]; then
    echo '{}' > "$CLAUDE_SETTINGS"
    chmod 600 "$CLAUDE_SETTINGS"      # Claude Code's own mode for this file
fi
python3 - "$CLAUDE_SETTINGS" << 'EOF'
import json, sys

path = sys.argv[1]
with open(path) as f:
    settings = json.load(f)

entry = {
    "matcher": "Bash",
    "hooks": [{"type": "command",
               "command": '"$HOME/.claude/hooks/block-flat-worktrees.sh"'}],
}
hooks = settings.setdefault("hooks", {})
pre = [e for e in hooks.get("PreToolUse", [])
       if "block-flat-worktrees" not in json.dumps(e)]
hooks["PreToolUse"] = pre + [entry]

with open(path, "w") as f:
    json.dump(settings, f, indent=2)
    f.write("\n")
print("  PreToolUse/Bash -> ~/.claude/hooks/block-flat-worktrees.sh")
EOF

# Ganymede skill. Its own repo, so it is cloned rather than vendored here.
GANYMEDE_SKILL="$HOME/.claude/skills/ganymede"
if [[ -d "$GANYMEDE_SKILL/.git" ]]; then
    echo "  Ganymede skill already cloned"
else
    echo "Cloning the Ganymede skill..."
    mkdir -p "$HOME/.claude/skills"
    git clone git@github.com:Ganymede-Bio/ganymede-skills.git "$GANYMEDE_SKILL" \
        || echo "  Clone failed — needs an SSH key with access to Ganymede-Bio"
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Open nvim and run :PlugInstall"
echo "3. Load iTerm2 state from: $DOTFILES/iTerm2 State.itermexport"
echo "   Then run Scripts > AutoLaunch > keymaps, or relaunch iTerm2, to"
echo "   install the Cmd chords nvim and the shell read as <D-...> keys"
echo "4. Install Google Sans Code font manually"
echo ""
