{
  description = "Romanian national exam data download script";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in {
          devShell = pkgs.mkShell {
            packages = with pkgs; [ git curl jq ];
          };
        }
    );
}
