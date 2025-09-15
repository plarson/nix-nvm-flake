{
  description = "nvm Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }: 
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in {
      devShells = forAllSystems (system: 
        let
          pkgs = nixpkgs.legacyPackages.${system};
          isDarwin = pkgs.stdenv.isDarwin;
          
          # Platform-specific packages
          linuxPkgs = with pkgs; lib.optionals (!isDarwin) [
            udev
            glibc
          ];
          
          commonPkgs = with pkgs; [
            gcc
            zsh
            vim
            git
            curl
            which
          ];
          
          # Use buildFHSUserEnv on Linux, regular mkShell on Darwin
          shell = if isDarwin then
            pkgs.mkShell {
              buildInputs = commonPkgs;
              shellHook = ''
                export NVM_DIR="$HOME/.nvm"
                echo "Using NVM_DIR: $NVM_DIR"
                if [ ! -d "$NVM_DIR" ]; then
                  echo "Installing nvm..."
                  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
                fi
                if [ -s "$NVM_DIR/nvm.sh" ]; then
                  source "$NVM_DIR/nvm.sh"
                  echo "nvm loaded successfully"
                fi
                if [ -s "$NVM_DIR/bash_completion" ]; then
                  source "$NVM_DIR/bash_completion"
                fi
              '';
            }
          else
            (pkgs.buildFHSUserEnv {
              name = "nvm-env";
              targetPkgs = pkgs: commonPkgs ++ linuxPkgs;
              runScript = "zsh";
              profile = ''
                export NVM_DIR="$HOME/.nvm"
                echo "Using NVM_DIR: $NVM_DIR"
                unset LD_LIBRARY_PATH
                if [ ! -d "$NVM_DIR" ]; then
                  echo "Installing nvm..."
                  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
                fi
                if [ -s "$NVM_DIR/nvm.sh" ]; then
                  source "$NVM_DIR/nvm.sh"
                  echo "nvm loaded successfully"
                fi
                if [ -s "$NVM_DIR/bash_completion" ]; then
                  source "$NVM_DIR/bash_completion"
                fi
              '';
            }).env;
        in {
          default = shell;
        }
      );
    };
}

