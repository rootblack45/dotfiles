#!/bin/bash

# https://github.com/Homebrew/install/blob/master/install.sh#L113-L125
# string formatters
if [[ -t 1 ]]
then
    tty_escape() { printf "\033[%sm" "$1"; }
else
    tty_escape() { :; }
fi
tty_mkbold() { tty_escape "1;$1"; }
tty_blue="$(tty_mkbold 34)"
tty_red="$(tty_mkbold 31)"
tty_bold="$(tty_mkbold 39)"
tty_reset="$(tty_escape 0)"

# ref: https://github.com/Homebrew/install/blob/master/install.sh#L65-L67
ohai() {
    printf "${tty_blue}[  ..  ]${tty_bold} %s${tty_reset}\n" "$@"
}

# ref: https://github.com/Homebrew/install/blob/master/install.sh#L9-L12
abort() {
    printf "${tty_red}[ ABRT ]${tty_bold} %s${tty_reset}\n" "$@"
    exit 1
}

# install Homebrew
ohai "Installing Homebrew.."
if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
then
    abort "Failed to install Homebrew"
fi

# install all dependencies in a Brewfile
ohai "Installing all dependencies in Brewfile"
if ! brew bundle --file=$(pwd -P)/Brewfile
then
    abort "Failed to install some of the dependencies in Brewfile"
fi

# run bootstrap
if ! $(pwd -P)/scripts/bootstrap.fish
then
    abort "dotfiles installation/update failed"
fi
