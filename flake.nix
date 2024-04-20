{
  description = "nvm Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      fhs = pkgs.buildFHSUserEnv {
        name = "nvm-env";
        targetPkgs = pkgs: with pkgs; [
          udev
          glibc
          gcc
          zsh
          vim
          git
        ];
        runScript = "zsh";
        profile = ''
          if [[ -x "NVM_DIR" ]]; then
            NVM_DIR="$HOME/.nvm"
            echo "Using default NVM_DIR: $NVM_DIR"
          fi
          export NVM_DIR
          unset LD_LIBRARY_PATH
          if [ ! -d "$NVM_DIR" ]; then
            git clone https://github.com/nvm-sh/nvm.git ~/.nvm
          fi
          [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        '';
      };
  in {
    devShells.${system}.default = fhs.env;
  };
}

