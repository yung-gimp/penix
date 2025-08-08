{
  inputs,
  lib,
  self,
  ...
}: let
  hosts = builtins.attrNames (
    lib.attrsets.filterAttrs (_n: t: t == "directory") (builtins.readDir ./nixosConfigurations)
  );

  mkHost = hostname:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        pkgs-stable = import inputs.nixpkgs-stable {
          system = "x86_64-linux";
        };

        inherit
          inputs
          hostname
          lib
          self
          ;
      };
      modules = [
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
in {
  flake = {
    nixosConfigurations = lib.genAttrs hosts mkHost;
    homeModules = lib.genAttrs homeMods mkHomeMod;
  };
}
