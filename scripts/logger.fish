#!/usr/bin/env fish

set -u tty_blue (set_color -o blue)
set -u tty_green (set_color -o green)
set -u tty_yellow (set_color -o yellow)
set -u tty_red (set_color -o red)
set -u tty_bold (set_color normal)(set_color -o)

function ohai
    echo $tty_blue"[  ..  ]"$tty_bold $argv
end

function ok
    echo $tty_green"[  OK  ]"$tty_bold $argv
end

function warn
    echo $tty_yellow"[ WARN ]"$tty_bold $argv
end

function abort
    echo $tty_red"[ ABRT ]"$tty_bold $argv
    exit 1
end
