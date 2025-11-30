{ lib, ... }:
let
  homeMods = lib.attrNames (
    lib.filterAttrs (n: v: v == "directory" && (builtins.readDir ./home-manager/${n}) ? "default.nix") (
      builtins.readDir ./home-manager
    )
  );
in
{
  flake = {
    nixosModules.codmod = ./nixos;

    homeModules = lib.genAttrs homeMods (homeMod: {
      imports = [ ./home-manager/${homeMod} ];
    });
  };
}
