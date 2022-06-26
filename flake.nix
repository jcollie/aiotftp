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
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
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
          '';
        };
      }
    );
}
