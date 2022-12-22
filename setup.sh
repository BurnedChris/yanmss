#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# Setup Finder Commands
# Show Library Folder in Finder
chflags nohidden ~/Library

# Show Hidden Files in Finder
defaults write com.apple.finder AppleShowAllFiles YES

# Show Path Bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show Status Bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Check for Homebrew, and then install it
if test ! "$(which brew)"; then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo "Homebrew installed successfully"
else
    echo "Homebrew already installed!"
fi

# Install XCode Command Line Tools
echo 'Checking to see if XCode Command Line Tools are installed...'
brew config

# Updating Homebrew.
echo "Updating Homebrew..."
brew update

# Upgrade any already-installed formulae.
echo "Upgrading Homebrew..."
brew upgrade

# Update the Terminal
# Install oh-my-zsh
echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
echo "Need to logout now to start the new SHELL..."
logout

# Install Git
echo "Installing Git..."
brew install git

# Install Powerline fonts
echo "Installing Powerline fonts..."
git clone https://github.com/powerline/fonts.git
cd fonts || exit
sh -c ./install.sh

# Install other useful binaries.
brew install speedtest_cli

# Core casks
brew cask install --appdir="/Applications" raycast
brew install git
brew install nvm

# Development tool casks
brew cask install --appdir="/Applications" visual-studio-code
brew cask install --appdir="/Applications" gitkraken
brew cask install --appdir="/Applications" postgres-unofficial
# snaplet
curl -sL https://app.snaplet.dev/get-cli/ | bash 
# doppler
brew install gnupg
brew install dopplerhq/cli/doppler

# Browsers
brew cask install --appdir="/Applications" firefox
brew cask install --appdir="/Applications" google-chrome
brew cask install --appdir="/Applications" microsoft-edge
brew cask install --appdir="/Applications" brave-browser

# Team Apps
brew cask install --appdir="/Applications" slack
brew cask install --appdir="/Applications" 1password
brew cask install --appdir="/Applications" linear-linear
brew cask install --appdir="/Applications" zoom
brew cask install --appdir="/Applications" around

# ThirdParty Apps
brew install --cask setapp

# Remove outdated versions from the cellar.
echo "Running brew cleanup..."
brew cleanup
echo "You're done!"
