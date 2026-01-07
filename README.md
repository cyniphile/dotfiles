# dotfiles

macOS development environment configuration.

## Quick Start

```bash
git clone git@github.com:cyniphile/dotfiles.git ~/dotfiles
cd ~/dotfiles
git checkout macos
./setup.sh
```

## What's Included

| Config | Description |
|--------|-------------|
| `.zshrc` | Zsh config with oh-my-zsh, pyenv, powerlevel10k |
| `.vimrc` | Neovim config with vim-plug |
| `.gitconfig` | Git settings |
| `settings.json` | VS Code settings (vim mode) |
| `keybindings.json` | VS Code keybindings |
| `yazi/` | Yazi file manager config |
| `.p10k.zsh` | Powerlevel10k prompt theme |
| `key_config.ron` | Gitui keybindings |

## Manual Steps

After running `setup.sh`:

1. **Neovim plugins**: Open nvim and run `:PlugInstall`

2. **iTerm2**: Load state from `iTerm2 State.itermexport`
   - Preferences > General > Preferences > Load preferences from custom folder

3. **Fonts**: Install [Google Sans Code](https://fonts.google.com/specimen/Source+Code+Pro) manually
   - Set as default font in iTerm2, Hack Nerd Font as non-ASCII fallback

4. **SSH key**: Generate and add to GitHub
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ssh-add --apple-use-keychain ~/.ssh/id_ed25519
   ```

5. **Chrome shortcuts** (optional): System Preferences > Keyboard > App Shortcuts
   - Add Cmd+F11 for "Next Tab", Cmd+F12 for "Previous Tab"

6. **VS Code**: Disable press-and-hold for vim mode
   ```bash
   defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
   ```

## Tools Installed

The setup script installs via Homebrew:
- `neovim`, `zsh`, `pyenv`
- `ripgrep`, `fd`, `fzf`, `yazi`, `gitui`, `lsd`
- `powerlevel10k`, `fortune`, `terminal-notifier`
- Hack Nerd Font

## Structure

```
dotfiles/
├── setup.sh          # Automated setup script
├── Shell configs     # .zshrc, .bashrc, .shellrc, etc.
├── .vimrc            # Neovim configuration
├── VS Code/          # settings.json, keybindings.json
├── yazi/             # File manager config
├── old/              # Archived/deprecated configs
└── iTerm2 State.itermexport
```
