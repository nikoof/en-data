{
  description = "Romanian national exam data download script";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        en-data = pkgs.writeShellApplication {
          name = "en-data";
          runtimeInputs = with pkgs; [ curl jq ];
          text = builtins.readFile ./en-data.sh;
        };
      in rec {
          devShell = pkgs.mkShell {
            packages = with pkgs; [ git curl jq ];
          };
        
          defaultPackage = en-data;
          defaultApp = flake-utils.lib.mkApp {
            drv = defaultPackage;
          };
        }
    );
}
