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
brew install git neovim zsh pyenv
brew install ripgrep fd fzf yazi gitui lsd
brew install fortune

# Powerlevel10k
brew install powerlevel10k

# Fonts
echo "Installing fonts..."
brew tap homebrew/cask-fonts 2>/dev/null || true
brew install --cask font-hack-nerd-font

# Oh My Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

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

# VS Code
link "$DOTFILES/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
link "$DOTFILES/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"

# Tools
link "$DOTFILES/.fdignore" "$HOME/.fdignore"

# Yazi - link all files
for f in "$DOTFILES/yazi/"*; do
    fname=$(basename "$f")
    link "$f" "$HOME/.config/yazi/$fname"
done

# fzf keybindings
echo "Setting up fzf..."
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# Claude Code notification hook
echo "Setting up Claude Code hooks..."
mkdir -p "$HOME/.claude"
if [[ ! -f "$HOME/.claude/settings.json" ]]; then
    cat > "$HOME/.claude/settings.json" << 'EOF'
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "terminal-notifier -message 'Claude Code needs your input' -title 'Claude Code' -sound Basso"
          }
        ]
      }
    ]
  }
}
EOF
    echo "  Created Claude Code notification hook"
else
    echo "  Claude Code settings already exist, skipping"
fi

# Install terminal-notifier for Claude notifications
brew install terminal-notifier 2>/dev/null || true

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Open nvim and run :PlugInstall"
echo "3. Load iTerm2 state from: $DOTFILES/iTerm2 State.itermexport"
echo "4. Install Google Sans Code font manually"
echo ""
