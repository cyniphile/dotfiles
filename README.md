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
| `.zshrc` | Zsh config with powerlevel10k and mise (no framework) |
| `.vimrc` | Neovim config with vim-plug |
| `.gitconfig` | Git settings |
| `settings.json` | VS Code settings (vim mode) |
| `keybindings.json` | VS Code keybindings |
| `claude/` | Claude Code global instructions, keybindings and hooks |
| `yazi/` | Yazi file manager config |
| `.p10k.zsh` | Powerlevel10k prompt theme |
| `key_config.ron` | Gitui keybindings |
| `RectangleConfig.json` | Rectangle window-manager shortcuts |

### Claude Code

`setup.sh` links `claude/CLAUDE.md`, `claude/keybindings.json` and
`claude/hooks/` into `~/.claude`.

`~/.claude/settings.json` is **not** tracked and **not** linked. Claude Code
writes an `autoMode` block into it that names private repos, internal domains
and buckets, and this repo is public. `.gitignore` blocks `claude/settings.json`
so a copy cannot be committed by accident. Carry that file between machines by
hand.

Because the file is untracked, `setup.sh` merges the one entry that needs a
tracked file — the `PreToolUse` hook that points at
`claude/hooks/block-flat-worktrees.sh`. The step is idempotent and keeps every
other key. The hook refuses `git worktree add` into a direct child of `~/dev`,
which is the rule `CLAUDE.md` states. It needs `jq`.

The `ganymede` skill is a clone of `Ganymede-Bio/ganymede-skills`, not a copy
kept here. `setup.sh` clones it, which needs an SSH key with access to that org.

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
   - Add Cmd+F11 for "Select Previous Tab", Cmd+F12 for "Select Next Tab"

6. **VS Code**: Disable press-and-hold for vim mode
   ```bash
   defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
   ```

## Tools Installed

The setup script installs via Homebrew:
- `neovim`, `zsh`, `mise`
- `ripgrep`, `fd`, `fzf`, `yazi`, `gitui`, `lsd`, `jq`
- `powerlevel10k`, `fortune`, `terminal-notifier`
- Rectangle (cask)
- Hack Nerd Font

## Structure

```
dotfiles/
├── setup.sh          # Automated setup script
├── Shell configs     # .zshrc, .bashrc, .shellrc, etc.
├── .vimrc            # Neovim configuration
├── VS Code/          # settings.json, keybindings.json
├── claude/           # Claude Code: CLAUDE.md, keybindings.json, hooks/
├── nvim/after/       # Neovim after/ scripts (markdown URL conceal)
├── yazi/             # File manager config
├── old/              # Archived/deprecated configs
├── RectangleConfig.json  # Window manager shortcuts (copied in by setup.sh)
└── iTerm2 State.itermexport
```
