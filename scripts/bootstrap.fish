#!/usr/bin/env fish

set DOTFILES_ROOT (pwd -P)
set -Uu DOTFILES_PKG $DOTFILES_ROOT/packages

source $DOTFILES_ROOT/scripts/logger.fish

ohai "DOTFILES_ROOT=$DOTFILES_ROOT; DOTFILES_PKG=$DOTFILES_PKG"

ohai "Creating dotfiles symlink.."
for f in $DOTFILES_PKG/*/*.symlink
    ln -sf $f $HOME/.(basename $f .symlink)
        and ok "Created dotfile symlink for $f"
        or warn "Failed to create dotfile symlink for $f"
end

ohai "Creating conf.d symlink.."
for f in $DOTFILES_PKG/*/conf.d/*.fish
    ln -sf $f $HOME/.config/fish/conf.d/(basename $f)
        and ok "Created conf.d symlink for $f"
        or warn "Failed to create conf.d symlink for $f"
end

ohai "Configuring additional dependencies.."
for f in $DOTFILES_PKG/*/install.fish
    $f
        and ok "Configured dependency in $f"
        or warn "Failed to config dependency in $f"
end