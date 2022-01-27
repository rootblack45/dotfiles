#!/usr/bin/env fish

if ! fish_add_path -m (go env GOPATH)/bin
    fish_add_path (go env GOPATH)/bin
end
