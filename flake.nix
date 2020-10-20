{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = with nixpkgs.legacyPackages.${system};
            (extend prefer-remote-fetch).extend self.overlay;
        in
        with pkgs; {
          packages = {
            inherit (python3Packages) nsupdate gunicorn;
          };

          defaultPackage = pkgs.python3.withPackages (p: with p; [ nsupdate gunicorn ]);

          devShell = mkShell {
            preferLocalBuild = true;

            buildInputs = [ self.packages.${system}.defaultPackage ];
          };
        }) // {
      overlay = final: prev: with final; {
        python3 = prev.python3.override {
          packageOverrides = pkgs.callPackage ./deps.nix { };
        };
        python3Packages = python3.pkgs;
      };
    };
}
