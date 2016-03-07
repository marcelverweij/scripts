#!/bin/bash

echo "Set global settings? (y/N)"
echo "	Dock: autohide; size 36px;"
echo "	Network shares: Disable writing .DS_Store files to network shares"
echo "	File extensions: Show all"
read -r response
if [ "$response" == "y" ]; then
	## Dock settings ##
	defaults write com.apple.dock autohide -bool true
	defaults write com.apple.dock tilesize -int 36
	defaults write com.apple.dock autohide-delay -float 0
	defaults write com.apple.dock autohide-time-modifier -float 0

	## Disable writing .DS_Store to network shares ##
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

	## Show all files ##
	defaults write com.apple.Finder AppleShowAllFiles -bool true
	defaults write com.apple.finder AppleShowAllFiles TRUE

	## Show all file extensions ##
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true

	exit 0
fi

## Install Xcode command-line developers tools ##
echo "Install Xcode command-line developer tools? (y/N)"
read -r response
if [ "$response" == "y" ]; then
	if [[ -d /Applications/Xcode.app/ ]] && [[ -f /usr/bin/xcode-select ]]; then
		/usr/bin/xcode-select --install
		sudo xcodebuild -license
		exit 0
	else
		echo "First install Xcode.app before installing the command line Xcode."
		echo "See Purchases in the App Store."
		open -a "/Applications/App Store.app"
		exit 0
	fi
fi

## Install Homebrew ##
echo "Install Homebrew? (y/N)"
read -r response
if [ "$response" == "y" ]; then
	if [ -f /usr/bin/ruby ]; then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		exit 0
	else
		echo "/usr/bin/ruby is missing, please install XCode via the App Store."
	fi
fi

## Install Homebrew cask ##
echo "Install Homebrew Cask? (y/N)"
read -r response
if [ "$response" == "y" ]; then
	# https://github.com/caskroom/homebrew-cask
	brew install caskroom/cask/brew-cask
fi

## Get vim config ##
echo "Get my vim config? (y/N)"
read -r response
if [ "$response" == "y" ]; then
	curl -L https://raw.githubusercontent.com/marcelverweij/dotfiles/master/.vimrc >>  ~/.vimrc
fi

