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

DOTFILES_DIR="$HOME/code/dotfiles"
CONFIG_HOME="$HOME/.config"

ln -sv "$DOTFILES_DIR/alacritty" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/fish/" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/tmux" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/git" "$CONFIG_HOME"
ln -sv "$DOTFILES_DIR/nvim/init.vim" "$CONFIG_HOME/nvim"
ln -sv "$DOTFILES_DIR/python/setup.cfg" "$HOME/code/python"
ln -sv "$DOTFILES_DIR/python/pylintrc" "$HOME/.pylintrc"

sudo tic -x "$HOME/code/dotfiles/tmux/tmux-256color.terminfo"

# ln -sv "$HOME/code/dotfiles/zsh/zshrc" "$HOME/.zshrc"

sudo spctl --master-dis able  # disable unidentified developer
