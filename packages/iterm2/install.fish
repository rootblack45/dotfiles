#!/usr/bin/env fish

defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$DOTFILES_PKG/iterm2"
