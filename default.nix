{
  inputs,
  lib,
  self,
  ...
}:
let
  hosts = builtins.attrNames (
    lib.attrsets.filterAttrs (_n: t: t == "directory") (builtins.readDir ./nixosConfigurations)
  );

  mkHost =
    hostname:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit
          inputs
          hostname
          lib
          self
          ;
      };
      modules = [
        inputs.agenix.nixosModules.default
        inputs.agenix-rekey.nixosModules.default
        ./nixosConfigurations/${hostname}
        inputs.home-manager.nixosModules.home-manager
        inputs.ff.nixosModules.freedpomFlake
        inputs.preservation.nixosModules.preservation
      ];
    };

  homeMods = builtins.attrNames (
    lib.attrsets.filterAttrs (_n: t: t == "directory") (builtins.readDir ./homeModules)
  );

  mkHomeMod = homeMod: {
    imports = [
      ./homeModules/${homeMod}
    ];
  };
in
{
  flake = {
    nixosConfigurations = lib.genAttrs hosts mkHost;
    homeModules = lib.genAttrs homeMods mkHomeMod;
  };
}
