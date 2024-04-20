# nix-nvm - An nvm nix flake

Setups up _all the things_ for you to do node dev with nvm on nixos.


# When would I need this?

- Yes, we have node specific modules for the 'nix' way, and we also have distrobox for the unnixway. 
- Sometimes you just want to clone __work__ repos and `nvm use`
- This is for those moments when you don't want to jump through nix shaped hoops.

# Install

To use nvm in nix:

```
nix develop github:fiq/nix-nvm-flake
```

Or clone and run `nix develop .`

I tend to `alias nvm-init=nix develop github:fiq/nix-pyenv-flake`
This will give you a new shell using this flake.

# NVM_DIR

If you don't set NVM_DIR to a folder of your choosing, it will default to `$HOME/.nvm`
