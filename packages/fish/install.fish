#!/usr/bin/env fish

if not type -q omf
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
end

omf install boxfish
