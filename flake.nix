{
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-22.05";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        python = pkgs.python310.withPackages (ps: with ps; [
          poetry
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            python
          ];
          shellHook = ''
            export POETRY_VIRTUALENVS_IN_PROJECT=true
            export PS1='\n\[\033[1;34m\][aiotftp:\w]\$\[\033[0m\] '
          '';
        };
        packages = {
          aiotftp = pkgs.poetry2nix.mkPoetryApplication {
            python = pkgs.python310;
            projectDir = ./.;
          };
          default = self.packages.${system}.aiotftp;
        };
      }
    );
}
