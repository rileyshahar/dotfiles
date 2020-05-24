sudo xcode-select --install

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew cask install dropbox google-chrome alfred telegram steam whatsapp iterm2 atom skim rstudio discord flux slack vlc java mactex
brew install r trash git youtube-dl tree zsh fzf ack python3 pipenv black

git config --global user.name "Riley Shahar"
git config --global user.email "riley.shahar@gmail.com"

# set up ssh key for github
# set up zsh config and oh my zsh

sudo spctl --master-disable  # disable unidentified developer
