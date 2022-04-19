#!/usr/bin/env fish

# ensure the go bin folder is exists
mkdir -p (go env GOPATH)/bin

if ! fish_add_path -m (go env GOPATH)/bin
    fish_add_path (go env GOPATH)/bin
end
