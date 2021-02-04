install guake, gnome extensions


```
sudo apt-get update
sudo apt-get install git
ssh-keygen -t rsa
```

add pub key to github

```
git clone git@github.com:cyniphile/dotfiles.git`
cd dotfiles
git checkout 'linux' branch
```
ensure username is correct in zshrc (e.g. 'cyniphile')

save guake settings?
    point iterm to dotfiles dir
    https://gitlab.com/gnachman/iterm2/-/issues/8029

```
sudo apt-get install neovim
sudo apt-get install zsh
```
install oh my zsh
```
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
install vim plug
```
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```
 
install vim plugins, in vim
```
:PlugInstall
```

remove defaults created by Oh my zsh etc
```
rm ~/.zshrc
rm ~/.bashrc
```

link config files
```
cd ~
ln -s dotfiles/.zshrc
ln -s dotfiles/.bash_aliases
ln -s dotfiles/.bash_profile
ln -s dotfiles/.vimrc
ln -s dotfiles/.bashrc
ln -s dotfiles/.tmux.conf
ln -s dotfiles/.shellrc
ln -s dotfiles/.gitconfig
ln -s dotfiles/.gitignore
# was having a weird permissions issue here, cped for now
ln -s dotfiles/luke-robbyrussell.zsh-theme .oh-my-zsh/themes

sudo apt-get install tmux
sudo apt-get install rg
sudo apt-get install fzf
```

To install useful key bindings and fuzzy completion:
```
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh
```

install tpm + prefix-I
```
git clone git@github.com:cyniphile/hunter_s_terminal.git
./hunter_s_terminal/install.sh
sudo apt-get install fortune
```

link nvim to vim
```
$ mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
$ ln -s ~/.vim $XDG_CONFIG_HOME/nvim
$ ln -s ~/.vimrc $XDG_CONFIG_HOME/nvim/init.vim
```

install pyenv
https://www.liquidweb.com/kb/how-to-install-pyenv-on-ubuntu-18-04/

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
