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
	defaults write NSGlobalDomain InitialKeyRepeat -int 10

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

	exit 0
fi


if [[ ! -f /usr/bin/xcode-select ]]; then
	echo "First install Xcode.app before installing the command line Xcode. See Purchases in the App Store."
	open -a "/Applications/App Store.app"
	exit 0
fi

if [[ ! -f /usr/local/bin/brew ]]; then
	echo "Install command line xcode:"
	/usr/bin/xcode-select --install

	echo "Agree to the xcode licence:"
	sudo xcodebuild -license

	echo "Install Homebrew:"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

	echo "Install Homebrew cask:"
	# https://github.com/caskroom/homebrew-cask
	brew install caskroom/cask/brew-cask
fi

if [[ ! -f ~/.vimrc ]]; then
	echo "Getting my latest .vimrc"
	curl -L https://raw.githubusercontent.com/marcelverweij/dotfiles/master/.vimrc >>  ~/.vimrc
fi
