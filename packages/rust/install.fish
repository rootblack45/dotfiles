#!/usr/bin/env fish

# ensure the cargo bin folder is exists
mkdir -p $HOME/.cargo/bin

if ! fish_add_path -m $HOME/.cargo/bin
    fish_add_path $HOME/.cargo/bin
end
