{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      python311
      python311Packages.requests
      python311Packages.beautifulsoup4
    ];   
  }
