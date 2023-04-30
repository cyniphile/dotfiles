install iterm, spectacle, istat menus, stretchly

Manually change iterm to swap cmd and ctrl keys

This (so certain shortcuts work): 
https://apple.stackexchange.com/questions/281033/sending-ctrlfunction-key-on-iterm2

install Homebrew
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`

```
brew install git
ssh-keygen -t ed25519 -C "your_email@example.com"
```

add pub key to github

```
git clone git@github.com:cyniphile/dotfiles.git
cd dotfiles
git checkout 'macos'
```
ensure username is correct in zshrc (e.g. 'cyniphile')

point iterm to dotfiles dir
https://gitlab.com/gnachman/iterm2/-/issues/8029

```
brew install neovim
brew install zsh
```
install oh my zsh
`sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
install vim plug
`sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'`
```
#Install vim plugins, in vim
:PlugInstall

rm ~/.zshrc
ln -s $HOME/dotfiles/.zshrc
ln -s $HOME/dotfiles/.bash_aliases
ln -s $HOME/dotfiles/.bash_profile
ln -s $HOME/dotfiles/.bashrc
ln -s $HOME/dotfiles/.tmux.conf
ln -s $HOME/dotfiles/.shellrc
ln -s $HOME/dotfiles/.gitconfig
ln -s $HOME/dotfiles/.gitignore
ln -s $HOME/dotfiles/key_config.ron $HOME/.config/git/key_bindings.ron 
ln -s $HOME/dotfiles/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
ln -s ~/dotfiles/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json

brew install tmux
brew install pyenv
brew install rg
brew install fd
brew install fzf
brew install gitui
# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install

```
install tpm + prefix-I

```
git clone git@github.com:cyniphile/hunter_s_terminal.git
./hunter_s_terminal/install.sh
brew install fortune
```

link nvim to vim
```
$ mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
$ ln -s ~/.vim $XDG_CONFIG_HOME/nvim
$ ln -s ~/dotfiles/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
```

install pip and packages
```
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

pip3 install neovim
pip install 'python-language-server[all]'
pip install jupyterlab
pip install jupyter-lsp
pip install --user ipykernel
pip install poetry

jupyter labextension install @krassowski/jupyterlab-lsp   
jupyter labextension install jupyterlab_vim
jupyter labextension install @jupyterlab/debugger
sudo jupyter serverextension enable --sys-prefix --py jupyter_lsp
```

install hack nerd font

```
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
```

```
brew install lsd
```

https://github.com/romkatv/evel10k#meslo-nerd-font-patched-for-powerlevel10k

```
brew install romkatv/powerlevel10k/powerlevel10k
echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
```

`ln -s $HOME/dotfiles/.p10k.zsh`


In chrome, go to to Preferences, Keyboard, Keyboard Shortcuts, App shortcuts,
and add cmd f10 to be Next tab and cmd f11 to be previous tab (language
dependent if system is in italian)

Fix press and hold: https://stackoverflow.com/questions/39972335/how-do-i-press-and-hold-a-key-and-have-it-repeat-in-vscode/44010683#44010683

Add SSH key to agent (for gitui to work)
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent

Change paste shortcut in iterm: https://apple.stackexchange.com/questions/155640/changing-the-default-keyboard-shortcuts-in-iterm2
