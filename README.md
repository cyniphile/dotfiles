install iterm

install Homebrew

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`

`brew install git`

`brew install neovim`

`ssh-keygen -t rsa`

add pub key to github

`git clone git@github.com:cyniphile/dotfiles.git`

checkout 'macos' branch

point iterm to dotfiles dir
https://gitlab.com/gnachman/iterm2/-/issues/8029

`brew install zsh`
ensure username is correct in zshrc

install oh my zsh
`sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

install vundle
Install vim plugins

```
brew install fzf
# To install useful key bindings and fuzzy completion:
$(brew --prefix)/opt/fzf/install

ln -s dotfiles/.zshrc
ln -S dotfiles/.bash_aliases
ln -s dotfiles/.bash_profile
ln -s dotfiles/vimrc
ln -s dotfiles/.bashrc
ln -s dotfiles/.tmux.conf
ln -s dotfiles/.shellrc

brew install tmux
```

install tpm

```
git clone git@github.com:cyniphile/hunter_s_terminal.git
./hunter_s_terminal/install.sh

brew install fortune

cp dotfiles/luke-robbyrussell.zsh-theme ./.oh-my-zsh/themes.
```


link nvim to vim
```
$ mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
$ ln -s ~/.vim $XDG_CONFIG_HOME/nvim
$ ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
```

pip

```
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

pip3 install neovim
```
