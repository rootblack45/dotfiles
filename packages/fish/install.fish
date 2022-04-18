#!/usr/bin/env fish

if not type -q omf
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
end

if not omf list | grep -q boxfish
    omf install boxfish
end

