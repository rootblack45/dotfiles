#!/usr/bin/env fish

if ! type -q omf
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
end

if ! omf list | grep -q boxfish
    omf install boxfish
    omf theme boxfish
end

# set default shell
if ! grep -q (which fish) /etc/shells
    sudo echo (which fish) >> /etc/shells
    chsh -s (which fish)
end

