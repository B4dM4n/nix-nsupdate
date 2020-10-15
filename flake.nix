{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs-channels/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlay = final: prev: with final; { };

        pkgs = with nixpkgs.legacyPackages.${system};
          (extend prefer-remote-fetch).extend overlay;

        python3 = pkgs.python3.override {
          packageOverrides = pkgs.callPackage ./deps.nix { };
        };
      in
      with pkgs; {
        packages = {
          inherit (python3.pkgs) nsupdate gunicorn;
        };

        defaultPackage = self.packages.${system}.nsupdate;

        devShell = mkShell {
          preferLocalBuild = true;

          buildInputs = with self.packages.${system}; [
            nsupdate
            gunicorn
          ];
        };
      });
}
