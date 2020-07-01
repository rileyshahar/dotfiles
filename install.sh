#!/usr/bin/env sh

sudo xcode-select --install

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew bundle install

# maybe we need something here to add fish to /ets/shells
chsh -s /usr/local/bin/fish

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# set up ssh key for github
# set up fish
# pull dotfiles from git

# install pynvim, isort, and pydocstyle either globally or in a pipenv

ln -sv "$HOME/code/dotfiles/alacritty/alacritty.yml" "$HOME/.alacritty.yml"
ln -sv "$HOME/code/dotfiles/fish/" "$HOME/.config/"
ln -sv "$HOME/code/dotfiles/tmux/tmux.conf" "$HOME/.tmux.conf"
ln -sv "$HOME/code/dotfiles/git/gitignore" "$HOME/.gitignore"
ln -sv "$HOME/code/dotfiles/git/gitconfig" "$HOME/.gitconfig"
ln -sv "$HOME/code/dotfiles/vim/init.vim" "$HOME/.config/nvim/init.vim"
ln -sv "$HOME/code/dotfiles/python/setup.cfg" "$HOME/code/python"
ln -sv "$HOME/code/dotfiles/python/pylintrc" "$HOME/.pylintrc"

# ln -sv "$HOME/code/dotfiles/zsh/zshrc" "$HOME/.zshrc"

sudo spctl --master-dis able  # disable unidentified developer
