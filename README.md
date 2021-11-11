install iterm, spectacle, sys monitor, Be Focused

install Homebrew
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`

```
brew install git
ssh-keygen -t rsa
```

add pub key to github

```
git clone git@github.com:cyniphile/dotfiles.git`
cd dotfiles
git checkout 'macos' branch
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

ln -s $HOME/dotfiles/.zshrc
ln -s $HOME/dotfiles/.bash_aliases
ln -s $HOME/dotfiles/.bash_profile
ln -s $HOME/dotfiles/vimrc
ln -s $HOME/dotfiles/.bashrc
ln -s $HOME/dotfiles/.tmux.conf
ln -s $HOME/dotfiles/.shellrc
ln -s $HOME/dotfiles/.gitconfig
ln -s $HOME/dotfiles/.gitignore
/* ln -s $HOME/dotfiles/luke-robbyrussell.zsh-theme ./.oh-my-zsh/themes */
ln -s $HOME/dotfiles/key_config.ron $HOME/Library/Application Support/gitui/key_config.ron
ln -s $HOME/dotfiles/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
ln -s ~/dotfiles/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json

brew install tmux
brew install rg
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
$ ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
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

https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k

```
brew install romkatv/powerlevel10k/powerlevel10k
echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
```

`ln -s $HOME/dotfiles/.p10k.zsh`