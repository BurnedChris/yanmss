#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v


# Define Function =ask=

ask () {
  osascript - "${1}" "${2}" "${3}" << EOF 2> /dev/null
    on run { _title, _action, _default }
      tell app "System Events" to return text returned of (display dialog _title with title _title buttons { "Cancel", _action } default answer _default)
    end run
EOF
}

# Define Function =ask2=

ask2 () {
  osascript - "$1" "$2" "$3" "$4" "$5" "$6" << EOF 2> /dev/null
on run { _text, _title, _cancel, _action, _default, _hidden }
  tell app "Terminal" to return text returned of (display dialog _text with title _title buttons { _cancel, _action } cancel button _cancel default button _action default answer _default hidden answer _hidden)
end run
EOF
}

# Define Function =p=

p () {
  printf "\n\033[1m\033[34m%s\033[0m\n\n" "${1}"
}

# Define Function =run=

run () {
  osascript - "${1}" "${2}" "${3}" << EOF 2> /dev/null
    on run { _title, _cancel, _action }
      tell app "Terminal" to return button returned of (display dialog _title with title _title buttons { _cancel, _action } cancel button 1 default button 2 giving up after 5)
    end run
EOF
}


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

# Install Rosetta 2
/usr/sbin/softwareupdate --install-rosetta --agree-to-license

a=$(ask2 "Set Computer Name and Hostname" "Set Hostname" "Cancel" "Set Hostname" $(ruby -e "print '$(hostname -s)'.capitalize") "false")
  if test -n $a; then
    sudo scutil --set ComputerName $(ruby -e "print '$a'.capitalize")
    sudo scutil --set HostName $(ruby -e "print '$a'.downcase")
  fi

# Check for Homebrew, and then install it
if test ! "$(which brew)"; then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed successfully - restart terminal and run the command again"
else
    echo "Homebrew already installed!"
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
brew install git

# Install nvm and node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

export NVM_DIR="$HOME/.nvm" # Manually load nvm so we don't need to reload the terminal
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install --lts
nvm use --lts
corepack enable # Makes yarn available globally

# Install Everfund project dependencies
brew install pkg-config cairo pango libpng jpeg giflib librsvg

# Development tool casks
brew install --cask visual-studio-code --appdir="/Applications"
brew install --cask postgres-unofficial --appdir="/Applications"

# snaplet
curl -sL https://app.snaplet.dev/get-cli/ | bash 
# doppler
brew install gnupg
brew install dopplerhq/cli/doppler

# Browsers
brew install --cask firefox --appdir="/Applications"
brew install --cask google-chrome --appdir="/Applications"
brew install --cask microsoft-edge --appdir="/Applications"
brew install --cask brave-browser --appdir="/Applications"

# Team Apps
brew install --cask slack --appdir="/Applications"
brew install --cask 1password --appdir="/Applications"
brew install --cask linear-linear --appdir="/Applications"
brew install --cask zoom --appdir="/Applications"
brew install --cask around --appdir="/Applications"

# ThirdParty Apps
brew install --cask setapp --appdir="/Applications"

# Remove outdated versions from the cellar.
echo "Running brew cleanup..."
brew cleanup
echo "You're done!"
fi
