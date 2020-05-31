sudo xcode-select --install

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew bundle install

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

git config --global user.name "Riley Shahar"
git config --global user.email "riley.shahar@gmail.com"

# set up ssh key for github
# set up zsh config and oh my zsh
# pull dotfiles from git

# install pynvim, isort, and pydocstyle either globally or in a pipenv

# ln -sv ~/code/dotfiles/.zshrc ~/
# ln -sv ~/code/dotfiles/.gitignore ~/
# ln -sv ~/code/dotfiles/.gitconfig ~/
# ln -sv ~/code/dotfiles/init.vim ~/

sudo spctl --master-dis able  # disable unidentified developer
