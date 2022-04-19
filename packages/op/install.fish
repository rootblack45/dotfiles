#!/usr/bin/env fish

ln -sf $DOTFILES_PKG/op/com.1password.SSH_AUTH_SOCK.plist $HOME/~/Library/LaunchAgents/com.1password.SSH_AUTH_SOCK.plist

if ! launchctl list | grep -q 'com.1password.SSH_AUTH_SOCK'
  launchctl load -w ~/Library/LaunchAgents/com.1password.SSH_AUTH_SOCK.plist
end

