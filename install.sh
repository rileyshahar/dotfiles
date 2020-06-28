sudo xcode-select --install

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew bundle install

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# set up ssh key for github
# set up zsh config and oh my zsh
# pull dotfiles from git

# install pynvim, isort, and pydocstyle either globally or in a pipenv

ln -sv ~/code/dotfiles/zsh/.zshrc ~/
ln -sv ~/code/dotfiles/tmux/.tmux.conf ~/
ln -sv ~/code/dotfiles/git/.gitignore ~/
ln -sv ~/code/dotfiles/git/.gitconfig ~/
ln -sv ~/code/dotfiles/vim/init.vim ~/.config/nvim/init.vim
ln -sv ~/code/dotfiles/python/setup.cfg ~/code/python
ln -sv ~/code/dotfiles/python/.pylintrc ~/

sudo spctl --master-dis able  # disable unidentified developer
