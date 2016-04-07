#!/bin/bash

echo "Set global settings? (y/N)"
read -r response
if [ "$response" == "y" ]; then

	####################
	### Power saving ###
	####################
	echo "Setting power saving settings"

	# Set system and display sleep time for Battery and Power Cord
	sudo pmset -b sleep 30 displaysleep 10 
	sudo pmset -c sleep 0  displaysleep 60

	# Require password after display sleep of 5 seconds
	defaults write com.apple.screensaver askForPassword -int 1
	defaults write com.apple.screensaver askForPasswordDelay -int 5

	# Disable screen saver
	defaults -currentHost write com.apple.screensaver idleTime 0

	##########################
	### Mouse and keyboard ###
	##########################
	echo "Setting mouse and keyboard settings"

	# Trackpad: Enable tap-to-click
	defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
	#defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
	#defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

	# Keyboard: On keypress, fast repeat key
	defaults write NSGlobalDomain KeyRepeat -int 1
	defaults write NSGlobalDomain InitialKeyRepeat -int 15

	# Keyboard: Disable autocorrection
	defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -int 0
	defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -int 0
	defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -int 0

	######################
	### Top menu icons ###
	######################
	echo "Setting top menu icons and settings"

	# Display icons
	defaults write com.apple.systemuiserver menuExtras -array \
		"/System/Library/CoreServices/Menu Extras/Battery.menu" \
		"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
		"/System/Library/CoreServices/Menu Extras/AirPort.menu" \
		"/System/Library/CoreServices/Menu Extras/Clock.menu"

	# Set the clock settings to analog
	defaults write com.apple.menuextra.clock IsAnalog -bool true

	# Show percent before battery icon
	defaults write com.apple.menuextra.battery ShowPercent "YES"

	############
	### Dock ###
	############
	echo "Setting dock settings"

	## Dock settings ##
	defaults write com.apple.dock autohide -bool true
	defaults write com.apple.dock tilesize -int 36
	defaults write com.apple.dock autohide-delay -float 0
	defaults write com.apple.dock autohide-time-modifier -float 0

	##############
	### Finder ###
	##############
	echo "Setting finder settings"

	# Disable writing .DS_Store to network shares
	defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

	# Show hidden files
	defaults write com.apple.Finder AppleShowAllFiles -bool true
	defaults write com.apple.finder AppleShowAllFiles TRUE

	# Show file extensions
	defaults write NSGlobalDomain AppleShowAllExtensions -bool true

	################
	### Hostname ###
	################

	echo "Set a hostname:"
	read HOSTNAME
	sudo scutil --set ComputerName "$HOSTNAME"
	sudo scutil --set LocalHostName "$HOSTNAME"
	sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$HOSTNAME"
	sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server ServerDescription -string "$HOSTNAME"
fi

if [[ ! -f ~/.vimrc ]]; then
	echo ""
	echo "Installing .vimrc"
	curl -L https://raw.githubusercontent.com/marcelverweij/dotfiles/master/.vimrc >>  ~/.vimrc
fi

if [[ ! -d /Applications/Xcode.app/ ]]; then
	echo ""
	echo "Install Xcode.app via the App Store, see the Purchases."
	open -a "/Applications/App Store.app"
	exit 0
fi

if [[ ! -d /Library/Developer/CommandLineTools/ ]]; then
	echo ""
	sudo xcodebuild -license

	echo ""
	echo "Please install 'command line developer tools':"
	/usr/bin/xcode-select --install
	echo "Please Wait for 'command line developer tools' to finish installing, before running this script again"
	exit 0
fi

if [[ -d /Library/Developer/CommandLineTools/ ]]; then
	if [[ ! -f /usr/local/bin/brew ]]; then
		echo ""
		echo "Installing Homebrew + Cask"
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		# https://github.com/caskroom/homebrew-cask
		brew install caskroom/cask/brew-cask
	fi
fi

if [[ -f /usr/local/bin/brew ]]; then
	echo ""
	echo "Installing my personal software via brew"
	brew install macvim
	brew install gnupg pass pwgen
	brew install tree watch unrar p7zip nmap
	brew install wget aria2

	brew cask install flux spectacle
	brew cask install google-chrome firefox
	brew cask install iterm2
	brew cask install evernote
	brew cask install github-desktop gitup
	brew cask install libreoffice macdown mactex lyx
	brew cask install vlc
fi
